# Updated `create_azure_service_connection.py`
"""
create_k8s_service_connection.py
-----------------------------------
Creates a Kubernetes service connection in Azure DevOps from a
Kubernetes ServiceAccount Secret JSON file.

IMPORTANT:
Azure DevOps expects:
- token -> BASE64 encoded value from secret.data.token
- certificate -> BASE64 encoded value from secret.data.ca.crt
- isCreatedFromSecretYaml -> "true"

DO NOT decode token/certificate before sending.

Usage:
    python create_k8s_service_connection.py \
        --secret secret.json \
        --cluster-url https://<EKS_ENDPOINT> \
        --name "My-K8s-Connection" \
        --pat  "<PAT_TOKEN>" \
        --project-id   "<GUID>" \
        --project-name "<PROJECT>"
"""
from dotenv import load_dotenv
import argparse
import base64
import json
import os
import sys
import httpx

load_dotenv()
# ─────────────────────────────────────────────────────────────────────────────
# Azure DevOps pipeline env vars
# ─────────────────────────────────────────────────────────────────────────────
SYSTEM_TEAMPROJECTID = os.environ.get("SYSTEM_TEAMPROJECTID", "")
SYSTEM_TEAMPROJECT = os.environ.get("SYSTEM_TEAMPROJECT", "")
SYSTEM_ACCESSTOKEN = os.environ.get("SYSTEM_ACCESSTOKEN", "")
SYSTEM_COLLECTIONURI = os.environ.get("SYSTEM_COLLECTIONURI","")


# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────
def _require(value: str, name: str) -> str:
    if not value or not value.strip():
        print(f"❌ '{name}' is empty — set the env var or pass the CLI flag.")
        sys.exit(1)
    return value.strip()


def _decode_b64(value: str) -> str:
    try:
        return base64.b64decode(value).decode("utf-8").strip()
    except Exception:
        return value.strip()


def _basic_auth(username: str, password: str) -> str:
    token = base64.b64encode(f"{username}:{password}".encode()).decode()
    return f"Basic {token}"


# ─────────────────────────────────────────────────────────────────────────────
# Load Kubernetes Secret
# ─────────────────────────────────────────────────────────────────────────────
def load_k8s_secret(secret_input: str) -> dict:
    if os.path.isfile(secret_input):
        with open(secret_input, "r", encoding="utf-8") as fh:
            raw = fh.read()
    else:
        raw = secret_input

    try:
        secret = json.loads(raw)
    except json.JSONDecodeError as exc:
        print(f"❌ Failed to parse Secret JSON: {exc}")
        sys.exit(1)

    if secret.get("kind") != "Secret":
        print("❌ JSON is not a Kubernetes Secret (kind != 'Secret').")
        sys.exit(1)

    data = secret.get("data", {})

    # IMPORTANT:
    # Azure DevOps expects BASE64 values directly from Secret.data
    token_b64 = data.get("token", "")
    ca_crt_b64 = data.get("ca.crt", "")
    namespace_b64 = data.get("namespace", "")

    if not token_b64:
        print("❌ 'data.token' missing in Kubernetes Secret.")
        sys.exit(1)

    if not ca_crt_b64:
        print("❌ 'data.ca.crt' missing in Kubernetes Secret.")
        sys.exit(1)

    namespace = _decode_b64(namespace_b64) if namespace_b64 else "default"

    return {
        # KEEP BASE64 VALUES
        "api_token_b64": token_b64,
        "ca_crt_b64": ca_crt_b64,
        "namespace": namespace,
        "secret_name": secret.get("metadata", {}).get("name", ""),
    }


# ─────────────────────────────────────────────────────────────────────────────
# Create Service Connection
# ─────────────────────────────────────────────────────────────────────────────
def create_service_connection(
    pat_token: str,
    username: str,
    connection_name: str,
    cluster_url: str,
    k8s: dict,
    project_id: str,
    project_name: str,
    org_url: str,
    accept_untrusted_certs: bool = True,
) -> dict:

    endpoint = (
        f"{org_url}/_apis/serviceendpoint/endpoints"
        f"?api-version=7.1-preview.4"
    )

    headers = {
        "Content-Type": "application/json",
        "Authorization": _basic_auth(username, pat_token),
        "User-Agent": (
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/124.0.0.0 Safari/537.36"
        ),
        "Accept": "application/json;api-version=7.1-preview.4",
        "X-TFS-FedAuthRedirect": "Suppress",
    }

    payload = {
        "name": connection_name,
        "type": "kubernetes",
        "url": cluster_url,
        "authorization": {
            "scheme": "Token",
            "parameters": {
                # MUST remain BASE64 encoded
                "apitoken": k8s["api_token_b64"],
                "serviceAccountCertificate": k8s["ca_crt_b64"],
                "isCreatedFromSecretYaml": "true",
            },
        },
        "data": {
            "authorizationType": "ServiceAccount",
            "acceptUntrustedCerts": str(accept_untrusted_certs).lower(),
            "namespace": k8s["namespace"],
        },
        "isReady": True,
        "serviceEndpointProjectReferences": [
            {
                "name": connection_name,
                "projectReference": {
                    "id": project_id,
                    "name": project_name,
                },
            }
        ],
    }

    print(f"\n{'=' * 70}")
    print(" Azure DevOps Kubernetes Service Connection Creation")
    print(f"{'=' * 70}")
    print(f" Organisation   : {org_url}")
    print(f" Endpoint       : {endpoint}")
    print(f" Connection Name: {connection_name}")
    print(f" Cluster URL    : {cluster_url}")
    print(f" Project        : {project_name} ({project_id})")
    print(f" Secret Name    : {k8s.get('secret_name', 'N/A')}")
    print(f" Namespace      : {k8s.get('namespace', 'N/A')}")
    print(f"{'=' * 70}\n")

    try:
        with httpx.Client(
            http2=False,
            verify=True,
            timeout=httpx.Timeout(60.0, connect=15.0),
            follow_redirects=False,
        ) as client:
            print(" Sending request ...", end=" ", flush=True)
            response = client.post(
                endpoint,
                json=payload,
                headers=headers,
            )
            print(f"HTTP {response.status_code}")

    except httpx.ConnectError as exc:
        print(f"\n❌ Connection error: {exc}")
        sys.exit(1)

    except httpx.TimeoutException:
        print("\n❌ Request timed out.")
        sys.exit(1)

    except httpx.RequestError as exc:
        print(f"\n❌ Request error: {exc}")
        sys.exit(1)

    # ───────────────────────────────────────────────────────────────────────
    # Handle Response
    # ───────────────────────────────────────────────────────────────────────
    if response.status_code in (200, 201):
        result = response.json()

        print("\n✅ Service connection created successfully!")
        print(f" Connection ID  : {result.get('id', 'N/A')}")
        print(f" Connection Name: {result.get('name', 'N/A')}")
        print(f" Type           : {result.get('type', 'N/A')}")
        print(f" Is Ready       : {result.get('isReady', 'N/A')}")

        return result

    elif response.status_code == 401:
        print("\n❌ HTTP 401 Unauthorized")
        print(
            " Ensure PAT has:\n"
            " - Service Connections (Read & Manage)\n"
            " - Valid organisation access"
        )
        sys.exit(1)

    elif response.status_code == 409:
        print("\n⚠️ Service connection already exists.")
        sys.exit(1)

    else:
        print(f"\n❌ Request failed with HTTP {response.status_code}")

        try:
            print(json.dumps(response.json(), indent=2))
        except Exception:
            print(response.text)

        sys.exit(1)


# ─────────────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────────────
def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawTextHelpFormatter,
    )

    parser.add_argument(
        "--secret",
        required=True,
        help="Path to K8s Secret JSON file or raw JSON string.",
    )

    parser.add_argument(
        "--cluster-url",
        required=True,
        help="Kubernetes API server URL.",
    )

    parser.add_argument(
        "--name",
        required=True,
        help="Service connection name.",
    )

    parser.add_argument(
        "--pat",
        default=SYSTEM_ACCESSTOKEN,
        help="Azure DevOps PAT.",
    )

    parser.add_argument(
        "--username",
        default="AzureDevOps",
        help="Basic Auth username.",
    )

    parser.add_argument(
        "--project-id",
        default=SYSTEM_TEAMPROJECTID,
        help="Azure DevOps Project ID.",
    )

    parser.add_argument(
        "--project-name",
        default=SYSTEM_TEAMPROJECT,
        help="Azure DevOps Project Name.",
    )

    parser.add_argument(
        "--org-url",
        default=SYSTEM_COLLECTIONURI.rstrip("/"),
        help="Azure DevOps Org URL.",
    )

    parser.add_argument(
        "--no-untrusted-certs",
        action="store_true",
        help="Reject untrusted TLS certs.",
    )

    args = parser.parse_args()

    pat = _require(args.pat, "SYSTEM_ACCESSTOKEN / --pat")
    project_id = _require(args.project_id, "SYSTEM_TEAMPROJECTID / --project-id")
    project_name = _require(args.project_name, "SYSTEM_TEAMPROJECT / --project-name")
    org_url = _require(args.org_url, "SYSTEM_COLLECTIONURI / --org-url")

    k8s = load_k8s_secret(args.secret)

    create_service_connection(
        pat_token=pat,
        username=args.username,
        connection_name=args.name,
        cluster_url=args.cluster_url,
        k8s=k8s,
        project_id=project_id,
        project_name=project_name,
        org_url=org_url,
        accept_untrusted_certs=not args.no_untrusted_certs,
    )


if __name__ == "__main__":
    main()
# WireGuard VPN Sidecar for Kubernetes

## Overview

This example demonstrates how to deploy a Kubernetes workload that routes outbound traffic through a WireGuard VPN tunnel using a sidecar container.

### Use Cases

* Secure outbound internet access
* Access private resources through VPN
* Fixed egress IP address
* Multi-cloud connectivity
* Secure access to on-premise systems

---

## Prerequisites

### WireGuard Server

You must already have a WireGuard server configured and reachable.

## Example WireGuard Client Configuration

```ini
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = vpn.example.com:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```
---

## Create Kubernetes Secret

Store the WireGuard configuration securely.

```bash
kubectl create namespace vpn-demo

kubectl create secret generic wireguard-config \
  --namespace vpn-demo \
  --from-file=wg0.conf
```

Verify:

```bash
kubectl get secret wireguard-config -n vpn-demo
```

---

## Deploy the Application

Apply the manifest:

```bash
kubectl apply -f wireguard-sidecar.yaml
```

---

## Verify WireGuard Tunnel

View logs:

```bash
kubectl logs -n vpn-demo deployment/demo-app -c wireguard
```

Verify interface:

```bash
kubectl exec -it -n vpn-demo deployment/demo-app -c wireguard -- wg show
```

Check external IP:

```bash
kubectl exec -it -n vpn-demo deployment/demo-app -c app -- curl ifconfig.me
```

The returned IP should be the VPN server public IP.

---

## Troubleshooting

### Tunnel Not Established

Check:

```bash
kubectl exec -it -n vpn-demo deployment/demo-app -c wireguard -- wg show
```

Look for:

```text
latest handshake
transfer: X received, Y sent
```

### DNS Resolution Fails

Verify DNS:

```bash
kubectl exec -it -n vpn-demo deployment/demo-app -c app -- nslookup google.com
```

### No Traffic Through VPN

Verify routes:

```bash
kubectl exec -it -n vpn-demo deployment/demo-app -c wireguard -- ip route
```

Expected:

```text
default dev wg0
```

---

## Cleanup

```bash
kubectl delete namespace vpn-demo
```

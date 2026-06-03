# Linux Cheat Sheet

## Files

```bash
ls -lah
pwd
find . -name '*.yaml'
```

## Search

```bash
grep -Ri error .
```

## Disk

```bash
df -h
du -sh *
```

## Processes

```bash
ps -ef
top
kill -9 PID
```

## Networking

```bash
curl -I https://google.com
ss -tulpn
```

## Logs

```bash
tail -f /var/log/syslog
journalctl -xe
```

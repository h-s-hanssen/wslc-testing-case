# wslc (WSL 3.0.3) vs Docker CLI vs Podman CLI

`wslc` is the container CLI shipped with WSL (3.0.x). Install: `wsl --install --no-distribution`.
Containers run in a lightweight WSL session VM; no separate daemon/Docker Desktop needed.
Findings come from the command sources at tag `3.0.3` of microsoft/WSL
(`src/windows/wslc/commands`); the commands were not executed in the Linux CI sandbox,
so verify on a Windows machine with WSL 3.0.3.

## Command surface in 3.0.3
- `container`: attach, cp, create, exec, export, inspect, kill, list, logs, prune, remove, restart, run, start, stats, stop
- `image`: build, import, inspect, list, load, prune, pull, push, remove, save, tag
- `network`: connect, create, disconnect, inspect, list, prune, remove
- `volume`: create, inspect, list, prune, remove
- `session` (wslc-specific): enter, list, run, shell, terminate
- also `registry`, `settings`, `system` (events, info), `inspect`, `version`
- global `--session` selects the WSL session/VM that holds the containers.

## Side by side (uses the `Dockerfile` in this repo)

| Task | wslc | docker | podman |
|---|---|---|---|
| Build | `wslc image build -t demo:1 .` | `docker build -t demo:1 .` | `podman build -t demo:1 .` |
| Build args / no cache | `wslc image build --build-arg GREETING=hi --no-cache -t demo:1 .` | same | same |
| List images | `wslc image list` | `docker images` / `docker image ls` | `podman images` |
| Run (foreground, auto-remove) | `wslc container run --rm demo:1 wslc` | `docker run --rm demo:1 docker` | `podman run --rm demo:1 podman` |
| Run detached + port | `wslc container run -d --name d1 -p 8080:8080 demo:1` | `docker run -d --name d1 -p 8080:8080 demo:1` | `podman run -d --name d1 -p 8080:8080 demo:1` |
| List containers | `wslc container list` | `docker ps` | `podman ps` |
| Logs | `wslc container logs d1` | `docker logs d1` | `podman logs d1` |
| Exec | `wslc container exec d1 sh` | `docker exec -it d1 sh` | `podman exec -it d1 sh` |
| Stop / remove | `wslc container stop d1` / `wslc container remove d1` | `docker stop d1` / `docker rm d1` | `podman stop d1` / `podman rm d1` |
| Inspect | `wslc container inspect d1` | `docker inspect d1` | `podman inspect d1` |
| Save image | `wslc image save -o demo.tar demo:1` | `docker save -o demo.tar demo:1` | `podman save -o demo.tar demo:1` |
| Volume | `wslc volume create v1` | `docker volume create v1` | `podman volume create v1` |
| Network | `wslc network create n1` | `docker network create n1` | `podman network create n1` |
| Cleanup | `wslc image prune`, `wslc container prune` | `docker system prune` | `podman system prune` |

(Flags such as `-t`, `--rm`, `-d`, `-p`, `-e`, `-v`, `--name`, `--entrypoint`, `--memory`, `--cpus`,
`--network` exist on `wslc container run`; exact output formats may differ.)

## Differences
- **Grouped syntax**: wslc uses `wslc <noun> <verb>` only. Docker/Podman also have shortcuts
  (`docker ps`, `docker build`, `docker rm`); wslc has no top-level `ps`/`build`/`run` aliases
  (verify with `wslc --help`), so scripts need adapting.
- **Architecture**: wslc has no persistent daemon or socket; Docker uses `dockerd`; Podman is daemonless
  and rootless-focused. wslc runs containers inside WSL session VMs (`wslc session ...`).
- **Not present in wslc 3.0.3**: compose, swarm, pods (Podman), `generate kube`, buildx/multi-platform,
  Docker-API socket compatibility, `login`/`logout` (credentials via `wslc registry`).
- **Dockerfile compatibility**: the same file builds with all three; wslc also accepts `Containerfile`
  naming in its SDK samples and supports `--build-arg`, `--target`, `--secret`, `--label`, `--iidfile`.
- **Extras in wslc**: `session` management, `settings`, built-in `--no-color` env handling, `--gpus`,
  `--health-*`, `--ulimit`, `--tmpfs`, `--shm-size` on run.
- **Podman-only**: pods, systemd integration, rootless user namespaces, `podman machine` (VM on Windows/macOS).

## Quick demo script (PowerShell)
```powershell
wslc image build -t demo:1 .
wslc container run --rm demo:1 wslc
docker build -t demo:1 . ; docker run --rm demo:1 docker
podman build -t demo:1 . ; podman run --rm demo:1 podman
```

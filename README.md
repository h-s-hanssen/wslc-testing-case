# wslc-testing-case
Testing the capabilities of `wslc`, the container support that shipped with WSL 3.03.

## Goal
Study how to build and run containers directly with `wslc` instead of a separate
tool such as Podman, to avoid an extra virtualization/management layer.

## Prerequisites
- Windows with WSL >= 3.03 (`wsl --version`, update with `wsl --update`)
- `wslc` available on PATH (`wslc --help`)

## Sample workload
`app/` holds a minimal Alpine image (`Containerfile`) that prints a greeting.

## Walkthrough
Run from the repository root in PowerShell. Subcommand names mirror the
Docker/Podman CLI; confirm exact syntax with `wslc --help` and adjust the
"Findings" section below.

```powershell
wslc build -t wslc-hello ./app       # build the image
wslc run --rm wslc-hello             # run it
wslc images                          # list images
wslc ps -a                           # list containers
```

For comparison, the Podman equivalent:

```powershell
podman build -t wslc-hello ./app
podman run --rm wslc-hello
```

## Comparison checklist
| Aspect                      | wslc | podman |
|-----------------------------|------|--------|
| Build time                  |      |        |
| Startup time                |      |        |
| Memory overhead (idle)      |      |        |
| Extra VM/layer required     |      |        |
| Volume mounts / networking  |      |        |

## Findings
_Record results and any CLI differences here._

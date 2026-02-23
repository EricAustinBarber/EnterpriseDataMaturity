set shell := ["powershell.exe", "-NoLogo", "-Command"]

just_version := "1.39.x"
python_version := "3.11.x"
rust_version := "1.82.x"
node_version := "22.x"
pnpm_version := "9.x"
azure_cli_version := "2.67.x"

default:
  @just --list

versions:
  @Write-Output "Required toolchain baseline:"
  @Write-Output "just={{just_version}}"
  @Write-Output "python={{python_version}}"
  @Write-Output "rust={{rust_version}}"
  @Write-Output "node={{node_version}}"
  @Write-Output "pnpm={{pnpm_version}}"
  @Write-Output "azure-cli={{azure_cli_version}}"

asdf-current:
  @wsl -l -q | Select-String . -Quiet | Out-Null
  @if ($LASTEXITCODE -ne 0) { Write-Output "No WSL distro installed. Install one first: wsl --install -d Ubuntu"; exit 1 }
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf current"

asdf-install:
  @wsl -l -q | Select-String . -Quiet | Out-Null
  @if ($LASTEXITCODE -ne 0) { Write-Output "No WSL distro installed. Install one first: wsl --install -d Ubuntu"; exit 1 }
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf plugin add python || true"
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf plugin add nodejs || true"
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf plugin add rust || true"
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf plugin add pnpm || true"
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf plugin add terraform || true"
  @wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf install"

asdf-doctor:
  @if (wsl -l -q | Select-String . -Quiet) { wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf --version"; wsl -e bash -lc "cd /mnt/c/Users/eabarber/CodeX/EnterpriseDataMaturity && asdf current" } else { Write-Warning "WSL distro not installed. asdf checks skipped. Install with: wsl --install -d Ubuntu" }
  @Write-Output "Non-asdf platform checks:"
  @if (Get-Command az -ErrorAction SilentlyContinue) { az version } else { Write-Warning "Azure CLI not found on PATH." }
  @if (Get-Command dotnet -ErrorAction SilentlyContinue) { $sdk = dotnet --list-sdks; if ($sdk) { dotnet --version } else { Write-Warning ".NET command found but no SDK installed." } } else { Write-Warning ".NET SDK not found on PATH." }

platform-doctor:
  @Write-Output "Checking Windows-hosted platform tooling..."
  @if (Get-Command az -ErrorAction SilentlyContinue) { az version } else { Write-Warning "Azure CLI not found on PATH." }
  @if (Get-Command dotnet -ErrorAction SilentlyContinue) { $sdk = dotnet --list-sdks; if ($sdk) { dotnet --version } else { Write-Warning ".NET command found but no SDK installed." } } else { Write-Warning ".NET SDK not found on PATH." }

workstation-doctor:
  @Write-Output "Running full workstation baseline checks (asdf + platform)..."
  @just asdf-doctor
  @just platform-doctor

doctor:
  @Write-Output "Checking local tooling..."
  @just --version
  @python --version
  @rustc --version
  @cargo --version
  @node --version
  @pnpm --version
  @az version
  @dot -V

setup-diagrams:
  @python -m venv .venv
  @.\\.venv\\Scripts\\python -m pip install --upgrade pip
  @.\\.venv\\Scripts\\pip install -r requirements\\diagrams.txt

diagram:
  @.\\.venv\\Scripts\\python diagrams\\enterprise_maturity_architecture.py
  @Write-Output "Architecture diagram generated in diagrams\\out\\"

setup-scorecard:
  @if (!(Test-Path .venv)) { python -m venv .venv }
  @.\\.venv\\Scripts\\python -m pip install --upgrade pip
  @.\\.venv\\Scripts\\pip install -r requirements\\scorecard.txt

scorecard-probe ENV="dev":
  @.\\.venv\\Scripts\\python scorecard\\scripts\\connection_probe.py --env {{ENV}}

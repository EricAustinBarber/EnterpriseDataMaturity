import argparse
import json
import socket
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Optional

import requests
import yaml
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient


@dataclass
class ProbeResult:
    source_id: str
    system: str
    source_type: str
    ok: bool
    details: str


def load_config(path: Path) -> Dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def resolve_secret_name(name_template: str, env: str) -> str:
    return name_template.replace("<env>", env)


def build_secret_client(vault_uri: str) -> SecretClient:
    credential = DefaultAzureCredential(exclude_interactive_browser_credential=False)
    return SecretClient(vault_url=vault_uri, credential=credential)


def get_secret_value(
    secret_client: Optional[SecretClient], secret_refs: Dict[str, str], key: str, env: str
) -> Optional[str]:
    if not secret_client:
        return None
    if key not in secret_refs:
        return None
    secret_name = resolve_secret_name(secret_refs[key], env)
    return secret_client.get_secret(secret_name).value


def probe_tcp(host: str, port: int, timeout: float = 5.0) -> ProbeResult:
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return ProbeResult(
                source_id="",
                system="",
                source_type="",
                ok=True,
                details=f"TCP reachable on {host}:{port}",
            )
    except Exception as exc:
        return ProbeResult(
            source_id="",
            system="",
            source_type="",
            ok=False,
            details=f"TCP probe failed for {host}:{port} -> {exc}",
        )


def probe_api(url: str, headers: Dict[str, str], timeout: float = 15.0) -> ProbeResult:
    try:
        response = requests.get(url, headers=headers, timeout=timeout)
        ok = 200 <= response.status_code < 300
        return ProbeResult(
            source_id="",
            system="",
            source_type="",
            ok=ok,
            details=f"API probe {url} -> HTTP {response.status_code}",
        )
    except Exception as exc:
        return ProbeResult(
            source_id="",
            system="",
            source_type="",
            ok=False,
            details=f"API probe failed for {url} -> {exc}",
        )


def run_probe(env: str, config_path: Path) -> List[ProbeResult]:
    cfg = load_config(config_path)
    env_cfg = cfg["environments"].get(env)
    if not env_cfg:
        raise ValueError(f"Environment '{env}' not found in config.")

    vault_uri = env_cfg.get("key_vault_uri")
    secret_client = build_secret_client(vault_uri) if vault_uri else None
    results: List[ProbeResult] = []

    for src in cfg.get("sources", []):
        if not src.get("active", False):
            continue
        probe_cfg = src.get("connection", {}).get("probe", {})
        if not probe_cfg.get("enabled", False):
            continue

        source_id = src.get("source_id", "unknown_source")
        system = src.get("system", "unknown_system")
        source_type = src.get("source_type", "unknown_type")
        conn = src.get("connection", {})
        secret_refs = conn.get("secret_refs", {})
        mode = probe_cfg.get("mode")

        if mode == "tcp":
            host = conn.get("endpoint")
            port = int(conn.get("port", 443))
            result = probe_tcp(host, port)
        elif mode == "api":
            if source_type == "databricks_sql_api":
                pat = get_secret_value(secret_client, secret_refs, "databricks_pat", env)
                if not pat:
                    result = ProbeResult(
                        source_id="",
                        system="",
                        source_type="",
                        ok=False,
                        details="Missing Databricks PAT secret reference or value.",
                    )
                else:
                    base = conn.get("workspace_url", "").rstrip("/")
                    path = probe_cfg.get("path", "/")
                    url = f"{base}{path}"
                    headers = {"Authorization": f"Bearer {pat}"}
                    result = probe_api(url, headers=headers)
            else:
                token = get_secret_value(secret_client, secret_refs, "api_token", env)
                base = conn.get("base_url", "").rstrip("/")
                path = probe_cfg.get("path", "/")
                url = f"{base}{path}"
                headers = {}
                if token:
                    headers = {"Authorization": f"Bearer {token}"}
                result = probe_api(url, headers=headers)
        else:
            result = ProbeResult(
                source_id="",
                system="",
                source_type="",
                ok=False,
                details=f"Unsupported probe mode '{mode}'",
            )

        result.source_id = source_id
        result.system = system
        result.source_type = source_type
        results.append(result)

    return results


def main() -> None:
    parser = argparse.ArgumentParser(description="Run secure connection probes for scorecard sources.")
    parser.add_argument("--env", required=True, choices=["dev", "test", "prod"])
    parser.add_argument(
        "--config",
        default="scorecard/source-connectors.yaml",
        help="Path to source connector config file.",
    )
    parser.add_argument(
        "--output",
        default="scorecard/out",
        help="Directory for JSON probe output.",
    )
    args = parser.parse_args()

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    results = run_probe(args.env, Path(args.config))
    payload = {
        "environment": args.env,
        "total_sources_probed": len(results),
        "passed": sum(1 for r in results if r.ok),
        "failed": sum(1 for r in results if not r.ok),
        "results": [r.__dict__ for r in results],
    }

    out_file = output_dir / f"connection_probe_{args.env}.json"
    out_file.write_text(json.dumps(payload, indent=2), encoding="utf-8")

    print(json.dumps(payload, indent=2))
    if payload["failed"] > 0:
        raise SystemExit(2)


if __name__ == "__main__":
    main()

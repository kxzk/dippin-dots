#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from typing import Any

DEFAULT_PROMOTIONS_API = "https://simplepractice.semaphoreci.com/api/v1alpha/promotions"
DEFAULT_PROMOTION_NAME = "Deploy to EKS staging"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Promote a Semaphore pipeline to a staging namespace."
    )
    parser.add_argument("--pipeline-id", required=True, help="Semaphore CI pipeline id.")
    parser.add_argument("--namespace", required=True, help="Target namespace, e.g. rev08.")
    parser.add_argument(
        "--promotion-name",
        default=DEFAULT_PROMOTION_NAME,
        help=f"Promotion name in Semaphore (default: {DEFAULT_PROMOTION_NAME!r}).",
    )
    parser.add_argument(
        "--promotions-api",
        default=os.environ.get("SEMAPHORE_PROMOTIONS_API", DEFAULT_PROMOTIONS_API),
        help="Promotions API URL. Defaults to SEMAPHORE_PROMOTIONS_API or simplepractice endpoint.",
    )
    parser.add_argument(
        "--semaphore-token",
        default=os.environ.get("SEMAPHORE_API_TOKEN", ""),
        help="Semaphore API token. Defaults to SEMAPHORE_API_TOKEN.",
    )
    parser.add_argument(
        "--no-override",
        action="store_true",
        help="Do not send override=true.",
    )
    parser.add_argument(
        "--format",
        choices=("human", "json"),
        default="human",
        help="Output format.",
    )
    return parser.parse_args()


def trigger_promotion(
    promotions_api: str,
    semaphore_token: str,
    pipeline_id: str,
    namespace: str,
    promotion_name: str,
    override: bool,
) -> tuple[int, str]:
    form_data: dict[str, Any] = {
        "name": promotion_name,
        "pipeline_id": pipeline_id,
        "CD_EKS_NAMESPACE": namespace,
    }
    if override:
        form_data["override"] = "true"

    payload = urllib.parse.urlencode(form_data).encode("utf-8")
    request = urllib.request.Request(
        promotions_api,
        data=payload,
        headers={"Authorization": f"Token {semaphore_token}"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            body = response.read().decode("utf-8", errors="replace")
            return int(response.getcode()), body
    except urllib.error.HTTPError as err:
        body = err.read().decode("utf-8", errors="replace")
        return int(err.code), body


def print_result(output_format: str, status_code: int, response_body: str) -> None:
    if output_format == "json":
        print(json.dumps({"status_code": status_code, "response": response_body}, indent=2))
        return
    print(f"HTTP_STATUS={status_code}")
    print(f"RESPONSE={response_body}")


def main() -> int:
    args = parse_args()
    if not args.semaphore_token:
        print("SEMAPHORE_API_TOKEN is required (or pass --semaphore-token).", file=sys.stderr)
        return 2

    status_code, response_body = trigger_promotion(
        promotions_api=args.promotions_api,
        semaphore_token=args.semaphore_token,
        pipeline_id=args.pipeline_id,
        namespace=args.namespace,
        promotion_name=args.promotion_name,
        override=not args.no_override,
    )
    print_result(args.format, status_code, response_body)
    return 0 if status_code == 200 else 1


if __name__ == "__main__":
    raise SystemExit(main())

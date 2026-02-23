#!/usr/bin/env python3
"""Select a matching milestone title for a release version.

This script is best-effort by design:
- It prints the chosen milestone title to stdout.
- It prints an empty string when no suitable milestone is found.
- It exits with code 0 even when GitHub API access is unavailable.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
from typing import Iterable


def normalize_version(version: str) -> str:
    return version[1:] if version.startswith("v") else version


def build_candidates(version: str) -> list[str]:
    v = normalize_version(version).strip()
    candidates = [
        f"v{v}",
        v,
        f"release/v{v}",
        f"release {v}",
        f"release v{v}",
        f"Release {v}",
        f"Release v{v}",
    ]
    parts = v.split(".")
    if len(parts) >= 2:
        mm = ".".join(parts[:2])
        candidates.extend(
            [
                f"v{mm}.x",
                f"{mm}.x",
                f"release v{mm}.x",
                f"Release v{mm}.x",
            ]
        )
    deduped: list[str] = []
    seen = set()
    for item in candidates:
        if item and item not in seen:
            deduped.append(item)
            seen.add(item)
    return deduped


def fetch_milestones(repo: str) -> list[dict]:
    cmd = ["gh", "api", f"repos/{repo}/milestones?state=all&per_page=100"]
    try:
        output = subprocess.check_output(cmd, text=True, stderr=subprocess.DEVNULL)
    except Exception:
        return []
    try:
        data = json.loads(output)
    except json.JSONDecodeError:
        return []
    return data if isinstance(data, list) else []


def score_milestone(title: str, state: str, version: str, candidates: Iterable[str]) -> int:
    lowered = title.strip().lower()
    if not lowered:
        return 0
    version_norm = normalize_version(version).lower()
    candidate_set = {item.lower() for item in candidates}

    if lowered in candidate_set:
        score = 100
    elif any(lowered.startswith(item) for item in candidate_set):
        score = 85
    elif version_norm and version_norm in lowered:
        score = 70
    else:
        parts = version_norm.split(".")
        mm = ".".join(parts[:2]) if len(parts) >= 2 else ""
        score = 50 if mm and mm in lowered else 0

    if state == "open":
        score += 5
    return score


def select_milestone(repo: str, version: str) -> str:
    milestones = fetch_milestones(repo)
    if not milestones:
        return ""

    candidates = build_candidates(version)
    best_title = ""
    best_score = 0
    for milestone in milestones:
        title = str(milestone.get("title", "")).strip()
        state = str(milestone.get("state", "")).strip().lower()
        score = score_milestone(title, state, version, candidates)
        if score > best_score:
            best_score = score
            best_title = title
    return best_title if best_score > 0 else ""


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", required=True, help="Release version, e.g. 0.6.6")
    parser.add_argument(
        "--repo",
        default=os.environ.get("GITHUB_REPOSITORY", ""),
        help="GitHub repository in owner/repo format (defaults to GITHUB_REPOSITORY).",
    )
    args = parser.parse_args()

    if not args.repo:
        print("")
        return 0

    print(select_milestone(args.repo, args.version))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

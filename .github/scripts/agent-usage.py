#!/usr/bin/env python3
"""Turn a Claude Code execution file into a markdown usage report.

Usage: agent-usage.py <execution-file>

The execution file is the JSON log that anthropics/claude-code-action writes
(output `execution_file`): a JSON array, or one JSON object per line, whose
last entry of type "result" carries the totals.
"""
import json
import sys


def load(path):
    text = open(path, encoding="utf-8").read().strip()
    if not text:
        return []
    try:
        data = json.loads(text)
        return data if isinstance(data, list) else [data]
    except json.JSONDecodeError:
        entries = []
        for line in text.splitlines():
            line = line.strip()
            if line:
                try:
                    entries.append(json.loads(line))
                except json.JSONDecodeError:
                    pass
        return entries


def fmt(n):
    return f"{int(n or 0):,}"


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    try:
        entries = load(sys.argv[1])
    except OSError as err:
        print(f"### Agent usage\n\nNo usage data: {err}")
        return
    result = next(
        (e for e in reversed(entries) if isinstance(e, dict) and e.get("type") == "result"),
        None,
    )
    if result is None:
        print("### Agent usage\n\nNo usage data: the run did not write a result entry.")
        return

    models = result.get("modelUsage") or {}
    print("### Agent usage\n")
    print("| Model | Input | Cache write | Cache read | Output | Total |")
    print("|---|---:|---:|---:|---:|---:|")
    grand = 0
    for name, m in models.items():
        parts = [
            m.get("inputTokens"),
            m.get("cacheCreationInputTokens"),
            m.get("cacheReadInputTokens"),
            m.get("outputTokens"),
        ]
        total = sum(int(p or 0) for p in parts)
        grand += total
        print(f"| `{name}` | " + " | ".join(fmt(p) for p in parts) + f" | {fmt(total)} |")
    if not models:
        u = result.get("usage") or {}
        parts = [
            u.get("input_tokens"),
            u.get("cache_creation_input_tokens"),
            u.get("cache_read_input_tokens"),
            u.get("output_tokens"),
        ]
        grand = sum(int(p or 0) for p in parts)
        print("| not reported | " + " | ".join(fmt(p) for p in parts) + f" | {fmt(grand)} |")
    print()
    print(f"- Total tokens: {fmt(grand)}")
    print(f"- Turns: {result.get('num_turns', 'not reported')}")
    duration = result.get("duration_ms")
    if duration is not None:
        print(f"- Duration: {round(duration / 60000, 1)} min")
    cost = result.get("total_cost_usd")
    if cost is not None:
        print(f"- Cost at API list price: ${cost:.2f} (a subscription run is not billed per token)")
    if result.get("is_error"):
        print(f"- The run ended with an error: `{result.get('subtype', 'unknown')}`")


if __name__ == "__main__":
    main()

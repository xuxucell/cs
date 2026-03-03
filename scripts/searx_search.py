#!/usr/bin/env python3
import json
import sys
import urllib.parse
import urllib.request

ENDPOINTS = [
    "https://priv.au/search",
    "https://search.inetol.net/search",
    "https://searx.be/search",
]


def fetch(url: str, timeout: int = 12):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 OpenClaw-Searx"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return json.loads(r.read().decode("utf-8", errors="ignore"))


def main():
    if len(sys.argv) < 2:
        print("Usage: searx_search.py <query> [limit]", file=sys.stderr)
        sys.exit(1)

    q = sys.argv[1]
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 8

    last_err = None
    for ep in ENDPOINTS:
        try:
            url = f"{ep}?q={urllib.parse.quote(q)}&format=json"
            data = fetch(url)
            results = data.get("results", [])[:limit]
            out = []
            for i, r in enumerate(results, 1):
                out.append({
                    "rank": i,
                    "title": r.get("title", ""),
                    "url": r.get("url", ""),
                    "content": (r.get("content", "") or "").strip(),
                    "engine": ",".join(r.get("engines", []) or []),
                    "source": ep,
                })
            print(json.dumps({"query": q, "source": ep, "results": out}, ensure_ascii=False, indent=2))
            return
        except Exception as e:
            last_err = f"{ep}: {e}"
            continue

    print(json.dumps({"query": q, "error": "all endpoints failed", "detail": last_err}, ensure_ascii=False))
    sys.exit(2)


if __name__ == "__main__":
    main()

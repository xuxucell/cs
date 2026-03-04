#!/usr/bin/env bash
set -euo pipefail

TITLE="${1:-自动化周报}"
BODY="${2:-这是由自动化流程发布的文章。}"
DATE="$(date +%F)"
SLUG="post-$(date +%s)"
ID="${DATE}-${SLUG}"

DATA_FILE="src/data/blog/${ID}.json"
PAGE_FILE="src/pages/blog/${ID}.astro"

mkdir -p src/data/blog src/pages/blog

export TITLE BODY DATE DATA_FILE
python3 - <<'PY'
import json, os
payload = {
    "title": os.environ["TITLE"],
    "description": "自动化发布",
    "pubDate": os.environ["DATE"],
    "body": os.environ["BODY"],
}
out = os.environ["DATA_FILE"]
os.makedirs(os.path.dirname(out), exist_ok=True)
with open(out, "w", encoding="utf-8") as f:
    json.dump(payload, f, ensure_ascii=False, indent=2)
PY

cat > "$PAGE_FILE" <<'EOF'
---
import BaseHead from '../../components/BaseHead.astro';
import Footer from '../../components/Footer.astro';
import Header from '../../components/Header.astro';
import { SITE_TITLE } from '../../consts';
import post from '../../data/blog/__POST_ID__.json';
---

<!doctype html>
<html lang="zh-CN">
  <head>
    <BaseHead title={`${post.title} | ${SITE_TITLE}`} description={post.description} />
    <style>
      main { width: min(860px, 92vw); margin: 0 auto; }
      article { line-height: 1.8; white-space: pre-wrap; }
      .meta { color: #666; margin-bottom: 20px; }
    </style>
  </head>
  <body>
    <Header />
    <main>
      <h1>{post.title}</h1>
      <p class="meta">{post.pubDate}</p>
      <article>{post.body}</article>
    </main>
    <Footer />
  </body>
</html>
EOF

# 替换页面中的占位符
sed -i "s|__POST_ID__|${ID}|g" "$PAGE_FILE"

echo "created data: $DATA_FILE"
echo "created page: $PAGE_FILE"

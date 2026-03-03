#!/usr/bin/env bash
set -euo pipefail

TITLE="${1:-自动化周报}"
BODY="${2:-这是由自动化流程发布的文章。}"
DATE="$(date +%F)"
SLUG="post-$(date +%s)"
FILE="src/content/blog/${DATE}-${SLUG}.md"

mkdir -p src/content/blog
cat > "$FILE" <<EOF
---
title: "$TITLE"
description: "自动化发布"
pubDate: "$DATE"
heroImage: "../../assets/blog-placeholder-1.jpg"
---

$BODY
EOF

echo "created: $FILE"

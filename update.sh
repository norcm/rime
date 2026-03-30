#!/usr/bin/env bash
set -euo pipefail

bash $PROJECT_DIR/other/plum/rime-install iDvel/rime-ice:others/recipes/full
#cat $PROJECT_DIR/me/rime/custom-dicts.txt | xargs -I {} curl -L -o ~/Library/Rime/cn_dicts/mydict/{} "https://dict.970630.xyz/rime/{}"

REPO_DIR="$PROJECT_DIR/me/rime"
GRAM_FILE="$REPO_DIR/configuration/wanxiang-lts-zh-hans.gram"
VERSION_FILE="$REPO_DIR/version.md"

export http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 all_proxy=socks5://127.0.0.1:1081 \
&& curl -L -o "$GRAM_FILE" "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram"

# 计算本次的时间和 MD5
CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
CURRENT_MD5=$(md5 -q "$GRAM_FILE")

# 从已有 version.md 中提取历史记录（跳过表头和分隔线，取数据行）
OLD_ROWS=""
if [ -f "$VERSION_FILE" ]; then
    OLD_ROWS=$(awk '/^\| [0-9]{4}-/' "$VERSION_FILE")
fi

# 生成新的 version.md，保留最近 10 条（含本次）
{
    echo "# 更新记录"
    echo ""
    echo "| 更新时间 | wanxiang-lts-zh-hans.gram文件MD5 |"
    echo "| --- | --- |"
    echo "| $CURRENT_TIME | $CURRENT_MD5 |"
    if [ -n "$OLD_ROWS" ]; then
        echo "$OLD_ROWS" | head -n 9
    fi
} > "$VERSION_FILE"

cd "$REPO_DIR"
cat delete-files.txt | xargs -I % rm -rf configuration/%

if [ -n "$(git status --porcelain)" ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git add -A
    git commit -m "update"
    git push origin "$CURRENT_BRANCH"
fi

/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
/Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --sync

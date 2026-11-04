#!/bin/bash
# check.sh - static checks for public/: no inline code (the CSP forbids it), every
# local link and stylesheet exists, every tool page is listed on the index.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "check: $*"; fail=1; }
while IFS= read -r -d '' f; do
    grep -qiE '<script|<style|[[:space:]]style=|[[:space:]]on[a-z]+=' "$f" && err "$f: inline script/style/handler"
    grep -q '<title>' "$f" || err "$f: no <title>"
    while IFS= read -r ref; do
        path=${ref%%#*}
        [ -z "$path" ] && continue
        target=public$path
        case $path in */) target=${target}index.html ;; esac
        [ -f "$target" ] || err "$f: broken link $ref"
    done < <(grep -oE '(href|src)="/tools/[^"]*"' "$f" | sed -E 's/^(href|src)="//; s/"$//')
done < <(find public -name '*.html' -print0)
for d in public/tools/*/; do
    name=$(basename "$d")
    grep -q "href=\"/tools/$name/\"" public/tools/index.html || err "tool $name is not listed on /tools/"
done
[ $fail = 0 ] && echo "check: ok"
exit $fail

#!/bin/bash

# =========================
# Reflection Finder (Color + Save Output)
# Usage: ./reflect.sh -i urls.txt -o output.txt
# =========================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[1;30m'
NC='\033[0m'

usage() {
    echo "Usage: $0 -i urls.txt -o output.txt"
    exit 1
}

while getopts "i:o:" opt; do
    case $opt in
        i) INPUT="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        *) usage ;;
    esac
done

[ -z "$INPUT" ] && usage
[ ! -f "$INPUT" ] && {
    echo -e "${RED}[ERROR] File not found: $INPUT${NC}"
    exit 1
}

# clear output file
if [ -n "$OUTPUT" ]; then
    > "$OUTPUT"
fi

# -------------------------
# helper functions
# -------------------------
show() {
    echo -e "$1"
    if [ -n "$OUTPUT" ]; then
        echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g' >> "$OUTPUT"
    fi
}

sep() {
    show "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

}

# -------------------------
# header
# -------------------------
show ""
show "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
show "${PURPLE}║                 PARAMETER REFLECTION FINDER                  ║${NC}"
show "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
show ""

total_urls=0
tested_urls=0
reflected_urls=0
reflected_params=0

# -------------------------
# main loop
# -------------------------
while read -r url; do

    [ -z "$url" ] && continue
    ((total_urls++))

    query="${url#*\?}"
    base="${url%%\?*}"

    [ "$query" = "$url" ] && continue

    ((tested_urls++))

    timestamp=$(date +%s)

    new_query=""
    IFS='&' read -ra params <<< "$query"

    i=1
    for param in "${params[@]}"; do
        key="${param%%=*}"
        payload="REFLECT_${i}_${timestamp}_XYZ"

        if [ -n "$new_query" ]; then
            new_query="${new_query}&${key}=${payload}"
        else
            new_query="${key}=${payload}"
        fi

        i=$((i+1))
    done

    test_url="${base}?${new_query}"

    body=$(curl -ksL --max-time 15 --connect-timeout 10 "$test_url" 2>/dev/null)

    reflected_list=()

    i=1
    for param in "${params[@]}"; do
        key="${param%%=*}"

        [ -z "$key" ] && { i=$((i+1)); continue; }

        payload="REFLECT_${i}_${timestamp}_XYZ"

        if grep -Fq "$payload" <<< "$body"; then
            reflected_list+=("$key")
            ((reflected_params++))
        fi

        i=$((i+1))
    done

    if [ ${#reflected_list[@]} -gt 0 ]; then

        ((reflected_urls++))

        sep

        show "${GREEN}✓ REFLECTION FOUND${NC}"
        sep

        show "${BLUE}URL:${NC}"
        show "${CYAN}$test_url${NC}"
        show ""

        show "${YELLOW}Reflected Parameters (${#reflected_list[@]}):${NC}"

        for p in "${reflected_list[@]}"; do
            show "   ${GREEN}✓${NC} ${YELLOW}$p${NC}"
        done

        show ""
        show "${BLUE}Total Parameters :${NC} ${#params[@]}"
        show "${BLUE}Reflections      :${NC} ${#reflected_list[@]}"

        sep
    fi

done < "$INPUT"

# -------------------------
# summary
# -------------------------
show ""
show "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
show "${PURPLE}║                          SUMMARY                           ║${NC}"
show "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
show ""

show "${CYAN}URLs Read             :${NC} $total_urls"
show "${CYAN}URLs Tested           :${NC} $tested_urls"
show "${GREEN}URLs With Reflection  :${NC} $reflected_urls"
show "${YELLOW}Reflected Parameters  :${NC} $reflected_params"

show ""
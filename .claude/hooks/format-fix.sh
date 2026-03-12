#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Only run for JS/TS files
if [[ ! "$file_path" =~ \.(ts|tsx|js|jsx|json)$ ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

output=$(bun run format:fix 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Format:fix failed for $file_path:" >&2
  echo "$output" >&2
  exit 2
fi

echo "Format:fix passed ✓"

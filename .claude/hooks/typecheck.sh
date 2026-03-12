#!/bin/bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Only run for TypeScript files
if [[ ! "$file_path" =~ \.(ts|tsx)$ ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if output=$(bun run typecheck 2>&1); then
  echo "TypeCheck passed ✓"
else
  echo "TypeCheck failed for $file_path:" >&2
  echo "$output" >&2
  exit 2
fi

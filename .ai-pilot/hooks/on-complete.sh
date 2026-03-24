#!/usr/bin/env bash
#
# on-complete.sh — Auto-run after Claude Code finishes a task
# Runs build/test and writes result summary
#

set -euo pipefail

RESULT_DIR=".ai-pilot/results"
mkdir -p "$RESULT_DIR"

# Detect project type and run appropriate checks
run_checks() {
    local exit_code=0

    # Node.js / JavaScript / TypeScript
    if [ -f "package.json" ]; then
        echo "📦 Detected Node.js project"
        if grep -q '"test"' package.json 2>/dev/null; then
            echo "🧪 Running npm test..."
            npm test 2>&1 || exit_code=$?
        fi
        if grep -q '"lint"' package.json 2>/dev/null; then
            echo "🔍 Running npm run lint..."
            npm run lint 2>&1 || exit_code=$?
        fi
        if grep -q '"build"' package.json 2>/dev/null; then
            echo "🔨 Running npm run build..."
            npm run build 2>&1 || exit_code=$?
        fi
    fi

    # Python
    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "🐍 Detected Python project"
        if command -v pytest &>/dev/null; then
            echo "🧪 Running pytest..."
            pytest 2>&1 || exit_code=$?
        fi
        if command -v flake8 &>/dev/null; then
            echo "🔍 Running flake8..."
            flake8 . 2>&1 || exit_code=$?
        fi
    fi

    # iOS / Swift
    if [ -f "*.xcodeproj" ] 2>/dev/null || [ -f "*.xcworkspace" ] 2>/dev/null; then
        echo "🍎 Detected iOS project"
        echo "⚠️  Run xcodebuild manually — too many configurations to auto-detect"
    fi

    # Flutter / Dart
    if [ -f "pubspec.yaml" ]; then
        echo "🦋 Detected Flutter project"
        if command -v flutter &>/dev/null; then
            echo "🔍 Running flutter analyze..."
            flutter analyze 2>&1 || exit_code=$?
        fi
    fi

    # Go
    if [ -f "go.mod" ]; then
        echo "🐹 Detected Go project"
        if command -v go &>/dev/null; then
            echo "🧪 Running go test..."
            go test ./... 2>&1 || exit_code=$?
        fi
    fi

    return $exit_code
}

# Main
echo ""
echo "🔄 AI Pilot — Auto-verification"
echo "================================"
echo ""

set +e
run_checks
CHECK_EXIT=$?
set -e

echo ""
if [ $CHECK_EXIT -eq 0 ]; then
    echo "✅ All checks passed"
else
    echo "❌ Some checks failed (exit code: $CHECK_EXIT)"
fi

echo ""
echo "Exit code: $CHECK_EXIT"
exit $CHECK_EXIT

#!/bin/bash

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Project root is one level up from bindings/
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "================================"
echo "Tree-Sitter Metal Test Runner"
echo "================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0

# Function to run a test
run_test() {
    local name="$1"
    local command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -n "Running $name tests... "

    if eval "$command" > /tmp/test_output_$$ 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        echo "  Error output:"
        cat /tmp/test_output_$$ | head -20 | sed 's/^/    /'
        rm -f /tmp/test_output_$$
        return 1
    fi
}

skip_test() {
    local name="$1"
    local reason="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    SKIPPED_TESTS=$((SKIPPED_TESTS + 1))

    echo -e "${YELLOW}SKIPPED${NC} $name tests: $reason"
}

# Check and run Rust tests
if command -v cargo &> /dev/null; then
    run_test "Rust" "cd '$PROJECT_ROOT' && cargo test --lib --quiet"
else
    skip_test "Rust" "cargo not found"
fi

# Check and run Go tests
if command -v go &> /dev/null; then
    run_test "Go" "cd '$PROJECT_ROOT/bindings/go' && go test -v"
else
    skip_test "Go" "go not found"
fi

# Check and run Node.js tests
if command -v npm &> /dev/null; then
    run_test "Node.js" "cd '$PROJECT_ROOT' && npm test"
else
    skip_test "Node.js" "npm not found"
fi

# Check and run Python tests
if command -v uv &> /dev/null; then
    run_test "Python" "cd '$PROJECT_ROOT' && uv run python -m unittest discover -s bindings/python/tests -q"
elif command -v python3 &> /dev/null; then
    if python3 -c "import tree_sitter" 2>/dev/null; then
        if python3 -c "import tree_sitter_metal" 2>/dev/null; then
            run_test "Python" "cd '$PROJECT_ROOT' && python3 -m unittest discover -s bindings/python/tests -q"
        else
            skip_test "Python" "tree_sitter_metal module not installed"
        fi
    else
        skip_test "Python" "tree-sitter Python module not installed"
    fi
else
    skip_test "Python" "python3 not found"
fi

# Check and run Swift tests
if command -v swift &> /dev/null; then
    run_test "Swift" "cd '$PROJECT_ROOT' && swift run TreeSitterMetalTests"
else
    skip_test "Swift" "swift not found"
fi

# Summary
echo ""
echo "================================"
echo "Test Summary"
echo "================================"
echo "Total:   $TOTAL_TESTS"
echo -e "Passed:  ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed:  ${RED}$FAILED_TESTS${NC}"
echo -e "Skipped: ${YELLOW}$SKIPPED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi

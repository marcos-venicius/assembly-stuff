#!/bin/bash

tests=(
  "" 0
  "()" 0
  "(" 1
  ")" 1
  "(()" 1
  "())" 1
  "(())" 0
  "((()))" 0
  "()()" 0
  "(()())" 0
  ")(" 1
  "())(()" 1
  "a + b * (c - d)" 0
  "(x + y" 1
  "x + y)" 1
  "(a(b)c)d" 0
  "((((((((()))))))))" 0
  "((((((((())))))))" 1
  "()()()()()()()" 0
  "((()()()()()))" 0
  "((()()()()())" 1
)

total=$(( ${#tests[@]} / 2 ))
pass=0

echo "🔍 Running $total tests..."

for ((i=0; i<${#tests[@]}; i+=2)); do
    input="${tests[i]}"
    expected="${tests[i+1]}"

    echo -n "Test $((i/2+1)): \"$input\" ... "

    echo -n "$input" | ./a.out >/dev/null 2>&1
    result=$?

    if [ "$result" -eq "$expected" ]; then
        echo -e "\033[1;32m✅ OK\033[0m"
        pass=$((pass+1))
    else
        echo -e "\003[1;31m❌ FAIL\033[0m (expected $expected, actual $result)"
    fi
done

echo ""
echo "📊 Test results: $pass / $total."


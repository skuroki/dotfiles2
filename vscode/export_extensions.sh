#!/usr/bin/env bash

# VS Code拡張機能リストを出力するスクリプト
# 現在インストールされている拡張機能をリスト化

echo "# VS Code拡張機能リスト"
echo "# 生成日時: $(date)"
echo ""

if command -v code >/dev/null 2>&1; then
    echo "# インストール済み拡張機能:"
    code --list-extensions
else
    echo "# VS Codeがインストールされていません"
    echo "# このファイルは手動で拡張機能リストを記述してください"
    echo ""
    echo "# 例:"
    echo "# ms-python.python"
    echo "# ms-vscode.vscode-typescript-next"
    echo "# github.copilot"
fi

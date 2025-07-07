#!/usr/bin/env bash

# VS Code拡張機能を自動インストールするスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

echo "🔧 VS Code拡張機能のインストールを開始します..."

# VS Codeがインストールされているか確認
if ! command -v code >/dev/null 2>&1; then
    echo "❌ VS Codeがインストールされていません。先にVS Codeをインストールしてください。"
    exit 1
fi

# 拡張機能リストファイルが存在するか確認
if [[ ! -f "$EXTENSIONS_FILE" ]]; then
    echo "❌ 拡張機能リストファイルが見つかりません: $EXTENSIONS_FILE"
    exit 1
fi

echo "📄 拡張機能リストを読み込んでいます: $EXTENSIONS_FILE"

# 拡張機能をインストール
while IFS= read -r line; do
    # コメント行と空行をスキップ
    if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    # 拡張機能名を取得（空白文字を削除）
    extension=$(echo "$line" | xargs)
    
    if [[ -n "$extension" ]]; then
        echo "🔌 インストール中: $extension"
        if code --install-extension "$extension" --force; then
            echo "✅ 成功: $extension"
        else
            echo "❌ 失敗: $extension"
        fi
    fi
done < "$EXTENSIONS_FILE"

echo "🎉 VS Code拡張機能のインストールが完了しました！"

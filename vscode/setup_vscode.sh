#!/usr/bin/env bash

# VS Code完全セットアップスクリプト
# 新しいMacでVS Codeの設定と拡張機能を自動で復元

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 VS Codeの完全セットアップを開始します..."

# 1. VS Codeがインストールされているか確認
if ! command -v code >/dev/null 2>&1; then
    echo "❌ VS Codeがインストールされていません。"
    echo "💡 先にBrewfileでVS Codeをインストールしてください: brew bundle"
    exit 1
fi

echo "✅ VS Codeが見つかりました"

# 2. 設定ファイルをインポート
echo ""
echo "🔧 VS Code設定をインポートしています..."
"$SCRIPT_DIR/manage_settings.sh" import

# 3. 拡張機能をインストール
echo ""
echo "🔌 VS Code拡張機能をインストールしています..."
"$SCRIPT_DIR/install_extensions.sh"

echo ""
echo "🎉 VS Codeのセットアップが完了しました！"
echo "💡 VS Codeを再起動すると、すべての設定と拡張機能が反映されます。"

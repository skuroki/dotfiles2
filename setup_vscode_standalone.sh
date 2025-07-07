#!/usr/bin/env bash

# VS Code専用セットアップスクリプト
# dotfiles2のセットアップとは独立してVS Codeだけをセットアップしたい場合に使用

set -e

echo "🚀 VS Code専用セットアップを開始します..."

# Brewでバインドラインストール（まだインストールされていない場合）
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrewがインストールされていません。"
    echo "💡 先にHomebrewをインストールしてください。"
    exit 1
fi

# VS Codeをインストール（まだインストールされていない場合）
if ! command -v code >/dev/null 2>&1; then
    echo "🔧 VS Codeをインストールしています..."
    brew install --cask visual-studio-code
    
    # codeコマンドが使えるまで少し待つ
    echo "⏳ VS Codeの初期化を待っています..."
    sleep 5
fi

# VS Codeが利用可能になるまで待機
max_attempts=30
attempt=0
while ! command -v code >/dev/null 2>&1 && [ $attempt -lt $max_attempts ]; do
    echo "⏳ VS Codeが利用可能になるまで待機中... ($((attempt + 1))/$max_attempts)"
    sleep 2
    ((attempt++))
done

if ! command -v code >/dev/null 2>&1; then
    echo "❌ VS Codeが利用可能になりませんでした。手動でVS Codeを起動して、codeコマンドをPATHに追加してください。"
    exit 1
fi

echo "✅ VS Codeが利用可能です"

# dotfiles2ディレクトリの確認
DOTFILES_DIR="$HOME/dotfiles2"
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "❌ dotfiles2ディレクトリが見つかりません: $DOTFILES_DIR"
    echo "💡 先にdotfiles2をクローンしてください。"
    exit 1
fi

# VS Code設定ディレクトリの確認
VSCODE_DIR="$DOTFILES_DIR/vscode"
if [[ ! -d "$VSCODE_DIR" ]]; then
    echo "❌ VS Code設定ディレクトリが見つかりません: $VSCODE_DIR"
    exit 1
fi

# VS Codeセットアップの実行
cd "$VSCODE_DIR"
./setup_vscode.sh

echo ""
echo "🎉 VS Code専用セットアップが完了しました！"
echo "💡 VS Codeを再起動すると、すべての設定と拡張機能が反映されます。"

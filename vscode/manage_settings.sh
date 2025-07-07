#!/usr/bin/env bash

# VS Code設定ファイルを管理するスクリプト
# 使用方法:
#   ./manage_settings.sh export - 現在の設定をdotfilesにエクスポート
#   ./manage_settings.sh import - dotfilesの設定をVS Codeに適用

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"

# VS Code設定ファイル
SETTINGS_JSON="settings.json"
KEYBINDINGS_JSON="keybindings.json"
SNIPPETS_DIR="snippets"

usage() {
    echo "使用方法: $0 [export|import]"
    echo "  export - 現在のVS Code設定をdotfilesにエクスポート"
    echo "  import - dotfilesの設定をVS Codeに適用"
    exit 1
}

export_settings() {
    echo "🔧 VS Code設定をエクスポートしています..."
    
    # VS Code設定ディレクトリが存在するか確認
    if [[ ! -d "$VSCODE_CONFIG_DIR" ]]; then
        echo "❌ VS Code設定ディレクトリが見つかりません: $VSCODE_CONFIG_DIR"
        exit 1
    fi
    
    # settings.jsonをコピー
    if [[ -f "$VSCODE_CONFIG_DIR/$SETTINGS_JSON" ]]; then
        cp "$VSCODE_CONFIG_DIR/$SETTINGS_JSON" "$SCRIPT_DIR/"
        echo "✅ $SETTINGS_JSON をエクスポートしました"
    else
        echo "⚠️  $SETTINGS_JSON が見つかりません"
    fi
    
    # keybindings.jsonをコピー
    if [[ -f "$VSCODE_CONFIG_DIR/$KEYBINDINGS_JSON" ]]; then
        cp "$VSCODE_CONFIG_DIR/$KEYBINDINGS_JSON" "$SCRIPT_DIR/"
        echo "✅ $KEYBINDINGS_JSON をエクスポートしました"
    else
        echo "⚠️  $KEYBINDINGS_JSON が見つかりません"
    fi
    
    # snippetsディレクトリをコピー
    if [[ -d "$VSCODE_CONFIG_DIR/$SNIPPETS_DIR" ]]; then
        rm -rf "$SCRIPT_DIR/$SNIPPETS_DIR"
        cp -r "$VSCODE_CONFIG_DIR/$SNIPPETS_DIR" "$SCRIPT_DIR/"
        echo "✅ $SNIPPETS_DIR をエクスポートしました"
    else
        echo "⚠️  $SNIPPETS_DIR ディレクトリが見つかりません"
    fi
    
    echo "🎉 VS Code設定のエクスポートが完了しました！"
}

import_settings() {
    echo "🔧 VS Code設定をインポートしています..."
    
    # VS Code設定ディレクトリを作成（存在しない場合）
    mkdir -p "$VSCODE_CONFIG_DIR"
    
    # settings.jsonをコピー
    if [[ -f "$SCRIPT_DIR/$SETTINGS_JSON" ]]; then
        cp "$SCRIPT_DIR/$SETTINGS_JSON" "$VSCODE_CONFIG_DIR/"
        echo "✅ $SETTINGS_JSON をインポートしました"
    else
        echo "⚠️  $SCRIPT_DIR/$SETTINGS_JSON が見つかりません"
    fi
    
    # keybindings.jsonをコピー
    if [[ -f "$SCRIPT_DIR/$KEYBINDINGS_JSON" ]]; then
        cp "$SCRIPT_DIR/$KEYBINDINGS_JSON" "$VSCODE_CONFIG_DIR/"
        echo "✅ $KEYBINDINGS_JSON をインポートしました"
    else
        echo "⚠️  $SCRIPT_DIR/$KEYBINDINGS_JSON が見つかりません"
    fi
    
    # snippetsディレクトリをコピー
    if [[ -d "$SCRIPT_DIR/$SNIPPETS_DIR" ]]; then
        rm -rf "$VSCODE_CONFIG_DIR/$SNIPPETS_DIR"
        cp -r "$SCRIPT_DIR/$SNIPPETS_DIR" "$VSCODE_CONFIG_DIR/"
        echo "✅ $SNIPPETS_DIR をインポートしました"
    else
        echo "⚠️  $SCRIPT_DIR/$SNIPPETS_DIR ディレクトリが見つかりません"
    fi
    
    echo "🎉 VS Code設定のインポートが完了しました！"
    echo "💡 VS Codeを再起動すると設定が反映されます。"
}

# 引数チェック
if [[ $# -ne 1 ]]; then
    usage
fi

case "$1" in
    export)
        export_settings
        ;;
    import)
        import_settings
        ;;
    *)
        usage
        ;;
esac

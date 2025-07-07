# VS Code設定管理

このディレクトリには、VS Codeの設定と拡張機能を管理するためのスクリプトが含まれています。

## ファイル構成

- `setup_vscode.sh` - VS Code完全セットアップスクリプト（新しいMacで実行）
- `manage_settings.sh` - 設定ファイルの管理（export/import）
- `install_extensions.sh` - 拡張機能の自動インストール
- `export_extensions.sh` - 現在の拡張機能リストの出力
- `extensions.txt` - インストール対象の拡張機能リスト
- `settings.json` - VS Code設定ファイル
- `keybindings.json` - キーバインド設定（存在する場合）
- `snippets/` - カスタムスニペット（存在する場合）

## 使用方法

### 新しいMacでのセットアップ

1. dotfiles2のクローンとBrewfileの実行が完了していることを確認
2. VS Code完全セットアップを実行:
   ```bash
   cd ~/dotfiles2/vscode
   ./setup_vscode.sh
   ```

### 設定の更新（現在のMacで）

拡張機能リストを更新:
```bash
cd ~/dotfiles2/vscode
./export_extensions.sh > extensions.txt
```

設定ファイルを更新:
```bash
cd ~/dotfiles2/vscode
./manage_settings.sh export
```

変更をコミット:
```bash
cd ~/dotfiles2
git add vscode/
git commit -m "Update VS Code settings and extensions"
git push
```

## 個別スクリプトの使用方法

### 設定管理
```bash
# 現在の設定をエクスポート
./manage_settings.sh export

# dotfilesの設定をインポート
./manage_settings.sh import
```

### 拡張機能管理
```bash
# 拡張機能リストを生成
./export_extensions.sh > extensions.txt

# 拡張機能を一括インストール
./install_extensions.sh
```

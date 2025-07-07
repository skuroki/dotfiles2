# dotfiles2

## Brewfileを使用した新しいセットアップ（推奨）

```bash
# Brewfileを使用したセットアップ
curl -fsSL https://raw.githubusercontent.com/skuroki/dotfiles2/master/install_with_brewfile.sh | bash -x
```

## 従来のAnsibleベースのセットアップ

```bash
curl -fsSL https://raw.githubusercontent.com/skuroki/dotfiles2/master/install.sh | bash -x
```

## Brewfileの使用方法

このリポジトリをクローンした後、以下のコマンドでパッケージをインストールできます：

```bash
cd dotfiles2
brew bundle
```

* Githubへの公開鍵置くのも一旦は手動
  * https://github.com/skuroki.keys からそのうちなんとかするかも

## 自動化していないこと

* 設定画面からやるシリーズ
  * capsキーをctrlキーにする
    * キーボード＞修飾キーから
  * 入力ソースをgoogle imeに切り替える
  * HyperSwitchの設定
    * バックグラウンド実行にする
    * 切り替えキーをCommand+Tabにする
* dockの整理

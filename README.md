# VS Code Remote DevelopmentでRailsアプリケーションのDocker開発環境にVSCodeから接続し、デバッグする

(自分用)
https://github.com/ishikawa999/rails_app_development_docker に自分用のカスタマイズを加えた物

# 利用手順

* このリポジトリを手元にClone

```bash
$ git clone https://github.com/ishikawa999/redmine_development_docker.git
$ cd /your/path/redmine_development_docker
```

* .envを書き換える
* update_devcontainer_setting.rbを実行

```bash
$ ruby update_devcontainer_setting.rb
```

* そのアプリケーション独自の設定や、自分の開発環境用のカスタマイズがしたい場合はscripts/custom_shell.shに書く(entrypointで実行される)

* VScodeに拡張機能[Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストール

* VScodeで/your/path/app_nameを開いた状態で、VSCodeのコマンドパレットからRemote Containers: Rebuild and Reopen in Container（もしくは右下に出てくるポップアップのReopen in Container）を選択 => ビルドが始まるはず
* 起動したら統合ターミナルのタブを追加し、
```bash
$ rails s -b 0.0.0.0
```
* 少し待つとhttp://localhost:[.envで指定したAPP_PORT]でアクセスできるようになる。

* テストの実行
```bash
$ bundle exec rake test RAILS_ENV=test
```

## おまけ(ほぼ使うことない)

### docker-compose.ymlを書き換えずにDBアダプターを切り替え(postgresql, sqlite3などでも同じようにできる)

```bash
$ export RAILS_DB_ADAPTER=mysql2
$ export RAILS_DB_HOST=mysqldb
$ export RAILS_DB_USERNAME=root

$ bundle update
$ bundle install
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ rails s -b 0.0.0.0
```

### selenium test

 selenium/standalone-chrome-debugイメージから持ってきたchromeを動かすためにCapybara周りで下のような感じに設定を追加する。
 app == docker-composeでrailsアプリケーションが動いているところのサービス名
 chrome:4444 == docker-compose　selenium/standalone-chrome-debugイメージのサービス名 + port

```diff
diff --git a/test/application_system_test_case.rb b/test/application_system_test_case.rb
index dce8b3a0e..e04ea91e5 100644
--- a/test/application_system_test_case.rb
+++ b/test/application_system_test_case.rb
@@ -22,7 +22,11 @@ require File.expand_path('../test_helper', __FILE__)
 class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
   DOWNLOADS_PATH = File.expand_path(File.join(Rails.root, 'tmp', 'downloads'))
 
+  Capybara.server_host = 'app'
+  Capybara.server_port = 3000
   driven_by :selenium, using: :chrome, screen_size: [1024, 900], options: {
+      browser: :remote,
+      url: "http://chrome:4444/wd/hub",
       desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
         'chromeOptions' => {
           'prefs' => {
@@ -35,6 +39,7 @@ class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
     }
 
   setup do
+    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
     clear_downloaded_files
     Setting.delete_all
     Setting.clear_cache

```

```
 bundle exec rake test TEST=test/system RAILS_ENV=test
```

そのときホスト側で
```
open vnc://localhost:5900
```
を実行すると実際に動いているChromeの画面を見ることができる。

### メールの内容をチェック

http://localhost:[.envで指定したMAILCATCHER_PORT] でにアクセスするとメールキャッチャーを開ける

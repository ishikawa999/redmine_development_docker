# VSCode Remote ContainerでRedmineのDocker開発環境にVSCodeから接続する

# 前提条件

* Docker Desktopを起動している
* Visual Studio Codeが利用できる

# 利用手順

* このリポジトリを手元にClone

```bash
$ git clone https://github.com/ishikawa999/redmine_development_docker.git
$ cd /your/path/redmine_development_docker
```

* .envを書き換える

```bash
# VSCodeで表示する名前。バージョンごとに作るときは変えた方が良いかも
APP_NAME=Redmine
# 開発中のRedmineに http://localhost:8000 でアクセス出来るようになる。8000を既に使っている場合は変える
APP_PORT=8000
# Seleniumのテストを実行するとき以外はそのまま
SELENIUM_PORT_1=4444
SELENIUM_PORT_2=5900
# Redmineから送信したメールを http://localhost:1080 で確認出来るようになる。1080を既に使っている場合は変える
MAILCATCHER_PORT=1080
# 開発するRedmineの推奨Rubyバージョンに応じて変える
RUBY_VERSION=2.6
# mysqlやsqlite3に変えても良い。mysqlの場合、docker-compose.ymlのMySQL関連のコメントアウトを外す
RAILS_DB_ADAPTER=postgresql
```

* update_devcontainer_setting.rbを実行

```bash
$ ruby update_devcontainer_setting.rb
```

* そのアプリケーション独自の設定や、自分の開発環境用のカスタマイズがしたい場合はscripts/custom_shell.shに書く(entrypointで実行される)

* VScodeに拡張機能[Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストール

* VScodeで/your/path/redmine_development_docker を開いた状態で、VSCodeのコマンドパレットからRemote Containers: Rebuild and Reopen in Container（もしくは右下に出てくるポップアップのReopen in Container）を選択 => ビルドが始まるはず

<img width="1359" alt="ScreenShot 2020-09-24 11 16 27" src="https://user-images.githubusercontent.com/14245262/94095500-cee85380-fe5c-11ea-8ff0-8bcb2a0f3ae4.png">

* VSCodeの左側のバーが赤くなり、左側のファイルツリーも表示されたらコンテナ内に入れている状態

<img width="1407" alt="ScreenShot 2020-09-24 11 59 24" src="https://user-images.githubusercontent.com/14245262/94095823-7b2a3a00-fe5d-11ea-89a6-20d513710384.png">

* ターミナルのタブを追加し、
```bash
$ rails s -b 0.0.0.0
```
* 少し待つと、ブラウザから http://localhost:[.envで指定したAPP_PORT] でRedmineにアクセスできるようになる。

<img width="1407" alt="ScreenShot 2020-09-24 11 59 51" src="https://user-images.githubusercontent.com/14245262/94095834-7feeee00-fe5d-11ea-87bd-3a8fc6242690.png">

* テストの実行
```bash
$ bundle exec rake test RAILS_ENV=test
```

## おまけ

### リポジトリを https://github.com/redmine/redmine.git から自分のリポジトリに変えたい

コンテナ内に入っている状態で、

```bash
$ git remote set-url origin <リポジトリのURL>
$ git fetch origin
$ git reset --hard origin/master
```

### VSCodeの拡張機能を増やしたい

.devcontainer/devcontainer.jsonのextensionsに拡張機能を追加し、VSCodeのコマンドパレットからRebuild and Reopen container

### Redmineから送信されるメールの内容をチェック

http://localhost:[.envで指定したMAILCATCHER_PORT] でにアクセスするとメールキャッチャーを開ける

### test/systemのテストを実行する場合

docker-compose.yml内のchrome:の塊のコメントアウトを外し、VSCodeのコマンドパレットからRebuild and Reopen container

 selenium/standalone-chrome-debugイメージから持ってきたchromeを動かすためにCapybara周りで下のように設定を追加する。
 app == docker-composeでrailsアプリケーションが動いているところのサービス名
 chrome:4444 == docker-compose selenium/standalone-chrome-debugイメージのサービス名 + port

```diff
diff --git a/test/application_system_test_case.rb b/test/application_system_test_case.rb
index 1a1e0cb4a..fedbe7d15 100644
--- a/test/application_system_test_case.rb
+++ b/test/application_system_test_case.rb
@@ -43,13 +43,17 @@ class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
                     }
                   }
                 )
-
+  options[:browser] = :remote
+  options[:url] = "http://chrome:4444/wd/hub"
+  Capybara.server_host = 'app'
+  Capybara.server_port = <.envのAPP_PORT(デフォルト8000)に入れた値に書き換える>
   driven_by(
     :selenium, using: :chrome, screen_size: [1024, 900],
     options: options
   )
 
   setup do
+    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
     # Allow defining a custom app host (useful when using a remote Selenium hub)
     if ENV['CAPYBARA_APP_HOST']
       Capybara.configure do |config|

```

```
 bundle exec rake test TEST=test/system RAILS_ENV=test
```

そのときホスト側で
```
open vnc://localhost:5900
```
を実行すると実際に動いているChromeの画面を見ることができる。

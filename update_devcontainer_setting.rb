print '.envを編集しましたか? [y|n]: '

case gets.chomp
when 'yes', 'YES', 'y'
  puts 'スクリプトを実行します.'
else
  puts 'スクリプトを終了します.'
  exit 1
end

unless Dir.exist?('app')
  print 'Clone Repository URLを入力してください: '
  repository_url = gets.chomp

  `git clone #{repository_url} app`
end

# Update devcontainer
devcontainer_content = File.read('.devcontainer/devcontainer.json')
env_content = File.read('.env')

app_home = env_content.split.find{|c| c.include?('APP_HOME=')}.gsub('APP_HOME=', '')
devcontainer_content.gsub!('/var/lib/app', app_home)

app_port = env_content.split.find{|c| c.include?('APP_PORT=')}.gsub('APP_PORT=', '')
devcontainer_content.gsub!('8000', app_port)

app_name = env_content.split.find{|c| c.include?('APP_NAME=')}.gsub('APP_NAME=', '')
devcontainer_content.gsub!('AppName', app_name)
File.write('.devcontainer/devcontainer.json', devcontainer_content)
puts '.devcontainer/devcontainer.jsonを変更しました'
unless Dir.exist?('app')
  `git clone https://github.com/redmine/redmine.git app`
  `cp overwrite_files/Gemfile.local app/Gemfile.local`
  `cp overwrite_files/database.yml app/config/database.yml`
  `cp overwrite_files/configuration.yml app/config/configuration.yml`
  `cp overwrite_files/additional_environment.rb app/config/additional_environment.rb`
  `cp -r overwrite_files/.vscode app/.vscode`
  puts 'appディレクトリにRedmineリポジトリをcloneしました'
end

# Update devcontainer
devcontainer_content = File.read('.devcontainer/devcontainer.json')
env_content = File.read('.env')

app_port = env_content.split.find{|c| c.include?('APP_PORT=')}.gsub('APP_PORT=', '')
devcontainer_content.gsub!('8000', app_port)

app_name = env_content.split.find{|c| c.include?('APP_NAME=')}.gsub('APP_NAME=', '')
devcontainer_content.gsub!('Redmine', app_name)
File.write('.devcontainer/devcontainer.json', devcontainer_content)
puts '.devcontainer/devcontainer.jsonを変更しました'

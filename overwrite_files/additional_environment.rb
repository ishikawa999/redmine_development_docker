# volumesの対象外にして速度が落ちないようにする
config.logger = Logger.new('../redmine.log', 2, 1000000)
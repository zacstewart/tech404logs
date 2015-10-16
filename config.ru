$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tech404/index'

if ENV['RACK_ENV'] == 'production'
  fork do
    Process.exec('bin/chatbot')
  end
end

run Tech404::Index::Application

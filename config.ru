$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tech404/index'

run Tech404::Index::Application

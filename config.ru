$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tech404/index'

use Rack::CommonLogger, Tech404::Index.logger
run Tech404::Index::Application

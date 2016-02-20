$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tech404logs'

use Rack::CommonLogger, Tech404logs.logger
run Tech404logs::Application

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tech404logs'
require 'rack/rewrite'

use Rack::CommonLogger, Tech404logs.logger
use Rack::Rewrite do
  r301 %r{.*}, %{http://#{Tech404logs.configuration.web_domain}$&}, :if => ->(rack_env) {
    rack_env['HTTP_HOST'] != Tech404logs.configuration.web_domain
  }
end
run Tech404logs::Application

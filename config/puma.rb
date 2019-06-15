require 'tech404logs'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

before_fork do
  Tech404logs.preboot

  run_chatbot if Tech404logs.production?
end

on_worker_boot do
  Tech404logs.preboot
end

def run_chatbot
  Thread.new do
    loop do
      begin
        puts 'Starting chatbot in a separate thread'
        Tech404logs::Connection.new.start
      rescue => error
        warn 'Chatbot crashed'
        warn error.message
      end
    end
  end
end

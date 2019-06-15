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

  if Tech404logs.production?
    Thread.new do
      loop do
        Process.fork do
          puts "Forked off chatbot process pid #{Process.pid}"
          Process.exec('bin/chatbot')
        end
        Process.wait
      end
    end
  end
end

on_worker_boot do
  Tech404logs.preboot
end

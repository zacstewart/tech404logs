require 'tech404/index'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

before_fork do
  Tech404::Index.preboot

  if Tech404::Index.production?
    fork do
      Process.exec('bin/chatbot')
    end
  end
end

on_worker_boot do
  Tech404::Index.preboot
end

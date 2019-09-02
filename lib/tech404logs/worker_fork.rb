module Tech404logs
  class WorkerFork
    def self.fork(&work)
      Kernel.fork do
        # Establish own connection to DB
        Tech404logs.preboot
        work.call
      end
    end
  end
end

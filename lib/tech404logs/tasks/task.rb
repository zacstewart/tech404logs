module Tech404logs
  module Tasks
    class Task

      def self.run
        new.run
      end

      def initialize
        @db = Sequel::Model.db
      end

      private

      attr_reader :db

      def confirm(prompt)
        confirmation = Readline.readline("#{prompt} [Y/n] ").strip
        yield if confirmation =~ /\A[yY]\Z/
      end

      def find_user(user_id)
        users.where(id: user_id).first
      end

    end
  end
end

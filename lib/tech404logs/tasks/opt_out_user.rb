require 'readline'
require 'pp'

module Tech404logs
  module Tasks
    class OptOutUser < Task

      def initialize
        super
        @users = Sequel::Model.db[:users]
      end

      def run
        puts "Please enter the user's ID (It looks like U03H0B61B)"
        user_id = Readline.readline("> ").strip

        db.transaction do
          if user = find_user(user_id)
            pp user
            confirm('Are you sure you want to opt this user out?') do
              opt_out_user!(user_id)
              puts 'User has been opted out.'
            end
          else
            puts "That user doesn't exist."
            confirm("Would you like to create an opted out record of them?") do
              create_opted_out_stub_user(user_id)
              puts 'Opted out stub user has been created.'
            end
          end
        end
      end

      private

      attr_reader :db, :users

      def create_opted_out_stub_user(user_id)
        users.insert_conflict(target: :id, update: {
          opted_out: Sequel[:excluded][:opted_out],
        }).insert(
          id: user_id,
          opted_out: true
        )
      end

      def opt_out_user!(user_id)
        users.where(id: user_id).update(opted_out: true)
      end

    end
  end
end

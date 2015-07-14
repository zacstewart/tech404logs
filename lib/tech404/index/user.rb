module Tech404
  module Index
    class User
      include DataMapper::Resource

      property :id, String, key: true
      property :name, String
      property :real_name, String
      property :image, String, length: 255

      def self.create_or_update(user)
        first_or_new(id: user.fetch('id')).tap do |record|
          record.name = user.fetch('name')
          record.real_name = user.fetch('profile').fetch('real_name')
          record.image = user.fetch('profile').fetch('image_48')
        end.save
      end
    end
  end
end

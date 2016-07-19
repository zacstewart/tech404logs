require 'thread'

module Tech404logs
  class User
    include DataMapper::Resource
    storage_names[:default] = 'users'

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

    def self.store(user_or_id)
      retries ||= 3

      case user_or_id
      when Hash
        create_or_update(user_or_id)
      when String
        first_or_create(id: user_or_id)
      end

    rescue => error
      # Ugly hack to recover from race conditions
      retries -= 1
      warn "#{error.class.name}: #{error.message}"
      retry if retries > 0
    end

    def pretty_name
      real_name || name
    end
  end
end

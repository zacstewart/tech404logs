require 'test_helper'

describe Handlers::UserHandler do
  subject { Handlers::UserHandler.new }

  describe '#handle' do
    let(:my_name) { 'Zac' }
    let(:id) { 'U123' }
    let(:event) { {
      'id' => id,
      'name' => my_name,
      'profile' => {
        'real_name' => 'Zac Stewart',
        'image_48' => 'http://example.com/image.jpg'
      }
    } }

    describe 'when the user has never been seen before' do
      it 'inserts a new User' do
        returned_id = subject.handle(event)
        User.first(id: id).name.must_equal(my_name)
        returned_id.must_equal(id)
      end
    end

    describe 'when the user has already been seen' do
      before do
        subject.handle(event.merge('name' => 'Caz'))
      end

      it 'inserts updates the existing User' do
        User.first(id: id).name.must_equal('Caz')

        subject.handle(event)
        User.first(id: id).name.must_equal(my_name)
      end
    end

    describe 'when the event is just an id' do
      let(:event) { id }

      it 'touches the User record' do
        subject.handle(event)
        user = User.first(id: id)
        user.id.must_equal(id)
        user.name.must_equal(my_name)
      end
    end
  end
end

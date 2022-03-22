require 'test_helper'

describe Handlers::UserHandler do
  subject { Handlers::UserHandler.new }
  let(:users) { Sequel::Model.db[:users] }

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
      it 'inserts a new User and returns it' do
        returned_id = subject.handle(event)
        _(users.where(id: id).first[:name]).must_equal(my_name)
        _(returned_id).must_equal(id)
      end
    end

    describe 'when the user has already been seen' do
      before do
        subject.handle(event.merge('name' => 'Caz'))
      end

      it "returns the user's id" do
        returned_id = subject.handle(event.merge('name' => 'Caz'))
        returned_id.must_equal(id)
      end

      it 'updates the existing User' do
        _(users.where(id: id).first[:name]).must_equal('Caz')

        subject.handle(event)
        _(users.where(id: id).first[:name]).must_equal(my_name)
      end
    end

    describe 'when the user has been opted out' do
      let(:id) { 'UOPTOUT' }

      before do
        users.insert(id: 'UOPTOUT', opted_out: true)
      end

      it 'does not update the User' do
        subject.handle(event)
        _(users.where(id: id).first[:name]).must_be_nil
      end
    end

    describe 'when the event is just an id' do
      let(:event) { id }

      it 'touches the User record and returns its id' do
        returned_id = subject.handle(event)
        returned_id.must_equal(id)
        _(users.where(id: id).count).must_equal(1)
      end
    end

  end
end

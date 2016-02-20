require 'test_helper'

describe UserMentionFilter do
  let(:users) { mock }
  let(:bob) { mock(name: 'bob') }
  subject { UserMentionFilter.new(text, user_repo: users) }

  describe '#apply' do
    describe 'when the mention includes a name' do
      let(:text) { 'Hello there <@U024BE7LH|bob>' }

      it "formats the message to include the user's name" do
        subject.apply.must_equal('Hello there @bob')
      end
    end

    describe 'when the mention does not include a name' do
      let(:text) { 'Hello there <@U024BE7LH>' }

      it 'finds the user by id to get their name' do
        users.expects(:get).with('U024BE7LH').returns(bob)
        subject.apply.must_equal('Hello there @bob')
      end
    end
  end
end

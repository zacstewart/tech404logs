require 'test_helper'

describe Handlers::MessageHandler do
  subject { Handlers::MessageHandler.new }

  describe '#handle' do
    let(:event) { {
      "client_msg_id" => "a uuid",
      "suppress_notification":false,
      "type" => "message",
      "text" => "Hello",
      "user" => "U123",
      "team" => "T123",
      "user_team" => "T123",
      "source_team" => "T123",
      "channel" => "C123",
      "event_ts" => "1564855899.055600",
      "ts" => "1564855899.055600"
    } }

    it 'inserts a Message' do
      returned_id = subject.handle(event)

      message = Message.first(id: returned_id)
      message.id.must_equal(returned_id)
      message.channel_id.must_equal('C123')
      message.user_id.must_equal('U123')
      message.text.must_equal('Hello')
      message.timestamp.must_equal(DateTime.parse('2019-08-03T14:11:39-04:00'))
    end

    it 'upserts a User' do
      subject.handle(event)
      User.first(id: 'U123').wont_equal(nil)
    end
  end
end

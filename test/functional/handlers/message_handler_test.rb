require 'test_helper'

describe Handlers::MessageHandler do
  subject { Handlers::MessageHandler.new }
  let(:messages) { Sequel::Model.db[:messages] }
  let(:users) { Sequel::Model.db[:users] }

  describe '#handle' do
    let(:user_id) { 'U123' }
    let(:event) { {
      "client_msg_id" => "a uuid",
      "suppress_notification":false,
      "type" => "message",
      "text" => "Hello",
      "user" => user_id,
      "team" => "T123",
      "user_team" => "T123",
      "source_team" => "T123",
      "channel" => "C123",
      "event_ts" => "1564855899.055600",
      "ts" => "1564855899.055600"
    } }

    it 'inserts a Message' do
      returned_id = subject.handle(event)

      message = messages.where(id: returned_id).first
      _(message[:id]).must_equal(returned_id)
      _(message[:channel_id]).must_equal('C123')
      _(message[:user_id]).must_equal(user_id)
      _(message[:text]).must_equal('Hello')
      _(message[:timestamp].utc.iso8601).must_equal(
        Time.new(2019, 8, 3, 18, 11, 39.55599).utc.iso8601)
    end

    it 'upserts a User' do
      subject.handle(event)
      _(users.where(id: user_id).count).must_equal(1)
    end

    describe 'when the User has opted-out' do
      let(:user_id) { 'UOPTOUT' }
      before do
        users.insert(id: user_id, opted_out: true)
      end

      it 'stores a message with the text blanked out' do
        returned_id = subject.handle(event)

        message = messages.where(id: returned_id).first
        _(message[:id]).must_equal(returned_id)
        _(message[:channel_id]).must_equal('C123')
        _(message[:user_id]).must_equal(user_id)
        _(message[:text]).must_equal('[redacted]')
        _(message[:timestamp].utc.iso8601).must_equal(
          Time.new(2019, 8, 3, 18, 11, 39.55599).utc.iso8601)
      end
    end
  end
end

require 'test_helper'

describe MessageHandler do
  let(:messages) { mock }
  subject { MessageHandler.new(a_message, messages: messages) }

  describe 'with a normal message' do
    let(:a_message) do
      {
        "type" => "message",
        "channel" => "C2147483705",
        "user" => "U2147483697",
        "text" => "Hello world",
        "ts" => "1355517523.000005"
      }
    end

    it 'stores the message' do
      messages.expects(:store).with(a_message)
      subject.handle
    end
  end
end

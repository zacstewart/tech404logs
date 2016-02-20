require 'test_helper'

describe EventHandler do
  let(:channel_joined_handler) { mock }

  subject do
    EventHandler.new(event,
                     channel_joined_handler: channel_joined_handler)
  end

  describe 'with a channel_joined event' do
    let(:event) { <<-EOS }
{
    "type": "channel_joined",
    "channel": {
        "id": "C024BE91L"
        // truncated
    }
}
    EOS

    it 'routes the event to the ChannelJoinedHandler' do
      channel_joined_handler.expects(:handle).with(
        'type' => 'channel_joined',
        'channel' => {'id' => 'C024BE91L'}
      )
      subject.handle
    end
  end
end

require 'test_helper'

describe ChannelJoinedHandler do
  let(:channel) do
    {
      "id" => "C024BE91L",
      "name" => "fun",
      "is_channel" => "true",
      "created" => 1360782804,
      "creator" => "U024BE7LH",
      "is_archived" => false,
      "is_general" => false,

      "members" => [
        "U024BE7LH"
      ],

      "topic" => {
        "value" => "Fun times",
        "creator" => "U024BE7LV",
        "last_set" => 1369677212
      },
      "purpose" => {
        "value" => "This channel is for fun",
        "creator" => "U024BE7LH",
        "last_set" => 1360782804
      },

      "is_member" => true,

      "last_read" => "1401383885.000061",
      "latest" => {  },
      "unread_count" => 0,
      "unread_count_display" => 0
    }
  end

  let(:channels) { mock }

  let(:event) do
    {
      "type" => "channel_joined",
      "channel" => channel
    }
  end

  subject { ChannelJoinedHandler.new(event, channels: channels) }

  it 'stores the channel' do
    channels.expects(:join).with(channel)
    subject.handle
  end
end

require 'test_helper'

describe ChannelMentionFilter do
  let(:channels) { mock }
  let(:general) { mock(name: 'general') }
  subject { ChannelMentionFilter.new(text, channel_repo: channels) }

  describe '#apply' do
    describe 'when the mention includes a name' do
      let(:text) { 'Go back to <#C1234|general>' }

      it 'formats the message to include the channel name' do
        subject.apply.must_equal('Go back to #general')
      end
    end

    describe 'when the mention does not include a name' do
      let(:text) { 'Go back to <#C1234>' }

      it 'finds the channel by id to get its name' do
        channels.expects(:get).with('C1234').returns(general)
        subject.apply.must_equal('Go back to #general')
      end
    end
  end
end

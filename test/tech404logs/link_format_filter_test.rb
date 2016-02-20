require 'test_helper'

describe LinkFormatFilter do
  subject { LinkFormatFilter.new(text) }

  describe '#apply' do
    describe 'when the link has anchor text' do
      let(:text) { 'Check this out: <http://zacstewart.com|zacstewart.com>' }

      it 'creates a link using the anchor text' do
        subject.apply.must_equal('Check this out: <a href="http://zacstewart.com">zacstewart.com</a>')
      end
    end

    describe 'when the link has no anchor text' do
      let(:text) { 'Check this out: <http://zacstewart.com>' }

      it 'uses the url for anchor text' do
        subject.apply.must_equal('Check this out: <a href="http://zacstewart.com">http://zacstewart.com</a>')
      end
    end
  end
end

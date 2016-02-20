describe MessageFormatFilter do
  subject { MessageFormatFilter }

  describe '::apply' do
    it 'renders emphasis' do
      subject.apply('Like, _whoa_').must_equal("Like, <em>whoa</em>")
      subject.apply('Like, _whoa_dude_').must_equal("Like, <em>whoa_dude</em>")
      subject.apply('Like, _whoa_dude_ that is neat_ !').must_equal("Like, <em>whoa_dude</em> that is neat_ !")
    end

    it 'renders bold' do
      subject.apply('I said *whoa* there').must_equal("I said <strong>whoa</strong> there")
    end

    it 'renders code' do
      subject.apply("Don't make me `function` lol").must_equal("Don't make me <code>function</code> lol")
    end

    it 'renders blockquotes' do
      subject.apply('> No you shut up').must_equal('<blockquote>No you shut up</blockquote>')
    end

    it 'renders preformated blocks' do
      subject.apply("```this\nis\npreformatted```").must_equal("<pre>this\nis\npreformatted</pre>")
    end
  end
end

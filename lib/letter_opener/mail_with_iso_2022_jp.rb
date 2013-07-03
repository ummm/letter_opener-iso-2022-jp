
module LetterOpener
  class MailWithIso2022Jp < SimpleDelegator

    def subject
      Iso2022JpToUtf8.decode(super)
    end

    def body
      Mail::Body.new(super.raw_source.encode("UTF-8", "ISO-2022-JP"))
    end

    def html_part &block
      if part = super
        MailWithIso2022Jp.new(part)
      end
    end

    def text_part &block
      if part = super
        MailWithIso2022Jp.new(part)
      end
    end

    def [] key
      Array(super).map { |f| PlainField.new(f.name, Iso2022JpToUtf8.decode(f.value), f.charset) }
    end
  end

  class PlainField
    def initialize name, value, charset
      @name, @value, @charset = name, value, charset
    end
    attr_reader :name, :value, :charset

    def to_str; @value; end
  end
end


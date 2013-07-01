
module LetterOpener
  class MailWithIso2022Jp
    extend Forwardable

    def initialize mail
      @mail = mail
    end

    def_delegators :@mail, :attachments, :multipart?, :content_type

    def subject
      @subject ||= Iso2022JpToUtf8.decode(@mail.subject)
    end

    def body
      @mail.body.to_s.encode("UTF-8", "ISO-2022-JP")
    end

    def html_part &block
      part = @mail.html_part(&block)
      MailWithIso2022Jp.new(part) if part
    end

    def text_part &block
      part = @mail.text_part(&block)
      MailWithIso2022Jp.new(part) if part
    end

    def [] key
      Array(@mail[key]).map { |header| Iso2022JpToUtf8.decode(header.value) }.join(", ")
    end
  end
end


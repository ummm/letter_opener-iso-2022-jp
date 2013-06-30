
module LetterOpener
  module MessageWithIso2022Jp
    def self.included klass
      klass.class_eval do
        def self.rendered_messages location, mail
          mail = MailWithIso2022Jp.new(mail) if mail.charset.upcase == "ISO-2022-JP"
          messages = []
          messages << new(location, mail, mail.html_part) if mail.html_part
          messages << new(location, mail, mail.text_part) if mail.text_part
          messages << new(location, mail) if messages.empty?
          messages.each(&:render)
          messages.sort
        end
      end
    end
  end
end


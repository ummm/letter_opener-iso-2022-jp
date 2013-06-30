
require 'letter_opener'
require 'nkf'
require 'forwardable'

require 'letter_opener/iso_2022_jp_to_utf8'
require 'letter_opener/mail_with_iso_2022_jp'
require 'letter_opener/message_with_iso_2022_jp'

LetterOpener::Message.send(:include, LetterOpener::MessageWithIso2022Jp)


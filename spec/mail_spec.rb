# -*- encoding: utf-8 -*-

require "spec_helper"

describe Mail do
  let(:location) { Mail.delivery_method.settings[:location] }

  context "given utf-8 encoded mail" do
    before do
      mail = Mail.new(charset: "UTF-8") do
        from            "差出人 <foo@example.com>"
        to              "宛先 <bar@example.com>"
        subject         "日本語のタイトル"
        content_type    "text/plain; charset=UTF-8"
        body            "日本語の本文 (UTF-8)"
      end

      mail.deliver
    end

    subject { 1 + 2 }
    it { expect(subject).to be 3 }
  end

  context "given iso-2022-jp encoded mail" do
    before do
      mail = Mail.new(charset: "ISO-2022-JP") do
        from            "差出人 <foo@example.com>"
        to              "宛先 <bar@example.com>"
        subject         "日本語のタイトル"
        content_type    "text/plain; charset=ISO-2022-JP"
        body            "日本語の本文 (ISO-2022-JP)"
      end

      mail.deliver
    end

    subject { 1 + 2 }
    it { expect(subject).to be 3 }
  end

  context "given multipart mail" do
    context "given utf-8 encoded mail" do
      before do
        mail = Mail.new(charset: "UTF-8") do
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "日本語のタイトル"

          text_part do
            content_type  "text/plain; charset=UTF-8"
            body          "日本語の本文 (UTF-8)"
          end.charset = "UTF-8"
          html_part do
            content_type  "text/html; charset=UTF-8"
            body          "日本語の本文 (UTF-8)"
          end.charset = "UTF-8"
        end

        mail.deliver
      end

      subject { 1 + 2 }
      it { expect(subject).to be 3 }
    end

  context "given iso-2022-jp encoded mail" do
      before do
        mail = Mail.new(charset: "ISO-2022-JP") do
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "日本語のタイトル"

          text_part do
            content_type  "text/plain; charset=ISO-2022-JP"
            body          "日本語の本文 (ISO-2022-JP)"
          end.charset = "ISO-2022-JP"
          html_part do
            content_type  "text/html; charset=ISO-2022-JP"
            body          "日本語の本文 (ISO-2022-JP)"
          end.charset = "ISO-2022-JP"
        end

        mail.deliver
      end

      subject { 1 + 2 }
      it { expect(subject).to be 3 }
    end
  end
end


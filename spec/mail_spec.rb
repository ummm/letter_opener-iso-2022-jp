# -*- encoding: utf-8 -*-

require "spec_helper"

require "uri"

describe Mail do
  before do
    Launchy.stub!(:open).and_return do |uri|
      path = URI.parse(uri).path
      dir = File.dirname(path)

      messages.clear
      Dir[File.join(dir, "**")].each(&messages.method(:<<))
    end
  end
  let(:messages) { @messages ||= [] }

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

    describe "messages" do
      subject { messages }
      its(:size) { should == 1 }
    end
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

    describe "messages" do
      subject { messages }
      its(:size) { should == 1 }
    end
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
            body          "<h1>日本語の本文 (UTF-8)</h1>"
          end.charset = "UTF-8"
        end

        mail.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 2 }
      end
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
            body          "<h1>日本語の本文 (ISO-2022-JP)</h1>"
          end.charset = "ISO-2022-JP"
        end

        mail.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 2 }
      end
    end
  end
end


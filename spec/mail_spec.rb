# -*- encoding: utf-8 -*-

require "spec_helper"

describe LetterOpener, launchy_mock: true do

  describe "text mail" do
    context "given utf-8 encoded mail" do
      before do
        Mail.new(charset: "UTF-8") {
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "日本語のタイトル"
          content_type    "text/plain; charset=UTF-8"
          body            "日本語の本文 (UTF-8)"
        }.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 1 }
      end
      describe "messages[#{0}]" do
        subject { File.read(messages[0]) }
        specify { expect(File.basename(messages[0])).to eq "plain.html" }
        specify { expect(subject).to match "<dd>&quot;差出人&quot; &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>&quot;宛先&quot; &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match '<pre id=\"message_body\">日本語の本文 \(UTF-8\)</pre>' }
      end
    end

    context "given iso-2022-jp encoded mail" do
      before do
        Mail.new(charset: "ISO-2022-JP") {
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル"
          content_type    "text/plain; charset=ISO-2022-JP"
          body            "日本語の本文 ISO-2022-JP バージョン"
        }.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 1 }
      end
      describe "messages[#{0}]" do
        subject { File.read(messages[0]) }
        specify { expect(File.basename(messages[0])).to eq "plain.html" }
        specify { expect(subject).to match "<dd>差出人 &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>宛先 &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match '<pre id=\"message_body\">日本語の本文 ISO-2022-JP バージョン</pre>' }
      end
    end
  end

  context "given multipart mail" do
    context "given utf-8 encoded mail" do
      before do
        Mail.new(charset: "UTF-8") {
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "日本語のタイトル"

          text_part {
            content_type  "text/plain; charset=UTF-8"
            body          "日本語の本文 (UTF-8)"
          }.charset = "UTF-8"

          html_part {
            content_type  "text/html; charset=UTF-8"
            body          "<h1>日本語の本文 (UTF-8)</h1>"
          }.charset = "UTF-8"
        }.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 2 }
      end
      describe "messages[#{0}]" do
        subject { File.read(messages[0]) }
        specify { expect(File.basename(messages[0])).to eq "plain.html" }
        specify { expect(subject).to match "<dd>&quot;差出人&quot; &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>&quot;宛先&quot; &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match '<pre id=\"message_body\">日本語の本文 \(UTF-8\)</pre>' }
      end
      describe "messages[#{1}]" do
        subject { File.read(messages[1]) }
        specify { expect(File.basename(messages[1])).to eq "rich.html" }
        specify { expect(subject).to match "<dd>&quot;差出人&quot; &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>&quot;宛先&quot; &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match "<h1>日本語の本文 \\(UTF-8\\)</h1>" }
      end
    end

    context "given iso-2022-jp encoded mail" do
      before do
        Mail.new(charset: "ISO-2022-JP") {
          from            "差出人 <foo@example.com>"
          to              "宛先 <bar@example.com>"
          subject         "とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル"

          text_part {
            content_type  "text/plain; charset=ISO-2022-JP"
            body          "日本語の本文 ISO-2022-JP バージョン"
          }.charset = "ISO-2022-JP"
          html_part {
            content_type  "text/html; charset=ISO-2022-JP"
            body          "<h1>日本語の本文 ISO-2022-JP バージョン</h1>"
          }.charset = "ISO-2022-JP"
        }.deliver
      end

      describe "messages" do
        subject { messages }
        its(:size) { should == 2 }
      end
      describe "messages[#{0}]" do
        subject { File.read(messages[0]) }
        specify { expect(File.basename(messages[0])).to eq "plain.html" }
        specify { expect(subject).to match "<dd>差出人 &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>宛先 &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match '<pre id=\"message_body\">日本語の本文 ISO-2022-JP バージョン</pre>' }
      end
      describe "messages[#{1}]" do
        subject { File.read(messages[1]) }
        specify { expect(File.basename(messages[1])).to eq "rich.html" }
        specify { expect(subject).to match "<dd>差出人 &lt;foo@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd>宛先 &lt;bar@example.com&gt;</dd>" }
        specify { expect(subject).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>" }
        specify { expect(subject).to match "<h1>日本語の本文 ISO-2022-JP バージョン</h1>" }
      end
    end
  end
end


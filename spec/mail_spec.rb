# -*- encoding: utf-8 -*-

require "spec_helper"

describe LetterOpener, launchy_mock: true do

  describe "text mail" do
    context "given utf-8 encoded mail" do
      before do
        Mail.new(charset: "UTF-8") {
          from            ["差出人1 <foo@example.com>", "差出人2 <hoge@example.com>"]
          to              ["宛先1 <bar@example.com>", "宛先2 <fuga@example.com>"]
          subject         "日本語のタイトル"
          content_type    "text/plain; charset=UTF-8"
          body            "日本語の本文 (UTF-8)"
        }.deliver
      end

      it "should UTF8 encoding messages" do
        aggregate_failures do
          expect(messages.size).to eq 1
          expect(messages[0].type).to eq :text
          expect(messages[0].raw).to match "<dd>&quot;差出人1&quot; &lt;foo@example.com&gt;, &quot;差出人2&quot; &lt;hoge@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd>&quot;宛先1&quot; &lt;bar@example.com&gt;, &quot;宛先2&quot; &lt;fuga@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd><strong>日本語のタイトル</strong></dd>"
          expect(messages[0].raw).to match '<pre id=\"message_body\">日本語の本文 \(UTF-8\)</pre>'
        end
      end
    end

    context "given iso-2022-jp encoded mail" do
      before do
        Mail.new(charset: "ISO-2022-JP") {
          from            ["差出人1 <foo@example.com>", "差出人2 <hoge@example.com>"]
          to              ["宛先1 <bar@example.com>", "宛先2 <fuga@example.com>"]
          subject         "とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル"
          content_type    "text/plain; charset=ISO-2022-JP"
          body            "日本語の本文 ISO-2022-JP バージョン"
        }.deliver
      end

      it "should UTF8 encoding messages" do
        aggregate_failures do
          expect(messages.size).to eq 1
          expect(messages[0].type).to eq :text
          # TODO: originally should be "<dd>&quot;差出人1&quot; &lt;foo@example.com&gt;, &quot;差出人2&quot; &lt;hoge@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd>差出人1 &lt;foo@example.com&gt;, 差出人2 &lt;hoge@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd>宛先1 &lt;bar@example.com&gt;, 宛先2 &lt;fuga@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>"
          expect(messages[0].raw).to match '<pre id=\"message_body\">日本語の本文 ISO-2022-JP バージョン</pre>'
        end
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

      it "should UTF8 encoding messages" do
        aggregate_failures do
          expect(messages.size).to eq 2
          expect(messages[0].type).to eq :text
          expect(messages[0].raw).to match "<dd>&quot;差出人&quot; &lt;foo@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd>&quot;宛先&quot; &lt;bar@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd><strong>日本語のタイトル</strong></dd>"
          expect(messages[0].raw).to match '<pre id=\"message_body\">日本語の本文 \(UTF-8\)</pre>'
          expect(messages[1].type).to eq :html
          expect(messages[1].raw).to match "<dd>&quot;差出人&quot; &lt;foo@example.com&gt;</dd>"
          expect(messages[1].raw).to match "<dd>&quot;宛先&quot; &lt;bar@example.com&gt;</dd>"
          expect(messages[1].raw).to match "<dd><strong>日本語のタイトル</strong></dd>"
          expect(messages[1].raw).to match "&lt;h1&gt;日本語の本文 \\(UTF-8\\)&lt;/h1&gt;"
        end
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

      it "should UTF8 encoding messages" do
        aggregate_failures do
          expect(messages.size).to eq 2
          expect(messages[0].type).to eq :text
          expect(messages[0].raw).to match "<dd>差出人 &lt;foo@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd>宛先 &lt;bar@example.com&gt;</dd>"
          expect(messages[0].raw).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>"
          expect(messages[0].raw).to match '<pre id=\"message_body\">日本語の本文 ISO-2022-JP バージョン</pre>'
          expect(messages[1].type).to eq :html
          expect(messages[1].raw).to match "<dd>差出人 &lt;foo@example.com&gt;</dd>"
          expect(messages[1].raw).to match "<dd>宛先 &lt;bar@example.com&gt;</dd>"
          expect(messages[1].raw).to match "<dd><strong>とてもとてもとてもとてもとてもとても very とてもとてもとてもとてもとてもとても長い日本語のタイトル</strong></dd>"
          expect(messages[1].raw).to match "&lt;h1&gt;日本語の本文 ISO-2022-JP バージョン&lt;/h1&gt;"
        end
      end
    end
  end
end


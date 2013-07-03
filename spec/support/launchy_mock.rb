
class MockMessage
  def initialize filename
    @filename = filename
    @raw = File.read(filename)
  end

  def type
    case File.basename(@filename)
    when "plain.html"; :text
    when "rich.html" ; :html
    end
  end
  attr_reader :raw
end

shared_context 'mimiced to receive mail', launchy_mock: true do
  before do
    Launchy.stub!(:open).and_return do |uri|
      path = URI.parse(uri).path
      dir = File.dirname(path)

      messages.clear
      Dir[File.join(dir, "**")].sort.each { |msg| messages << MockMessage.new(msg) }
    end
  end
  let(:messages) { @messages ||= [] }
end



shared_context 'mimiced to receive mail', launchy_mock: true do
  before do
    Launchy.stub!(:open).and_return do |uri|
      path = URI.parse(uri).path
      dir = File.dirname(path)

      messages.clear
      Dir[File.join(dir, "**")].sort.each(&messages.method(:<<))
    end
  end
  let(:messages) { @messages ||= [] }
end


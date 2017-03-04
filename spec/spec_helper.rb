
require "letter_opener"
require "mail-iso-2022-jp"
require "pry-byebug"

require "letter_opener-iso-2022-jp"

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with(:rspec) { |c| c.syntax = :expect }
end

Mail.defaults do
  delivery_method LetterOpener::DeliveryMethod, :location => File.expand_path('../../tmp/letter_opener', __FILE__)
end


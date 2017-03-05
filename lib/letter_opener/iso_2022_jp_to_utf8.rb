
module LetterOpener
  module Iso2022JpToUtf8
    def decode value
      [*value].map { |v| NKF.nkf("-m -w -J", v) }.join(', ')
    end
    module_function :decode
  end
end


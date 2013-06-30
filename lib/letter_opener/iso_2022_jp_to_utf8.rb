
module LetterOpener
  module Iso2022JpToUtf8
    def decode value
      NKF.nkf("-m -w -J", value)
    end
    module_function :decode
  end
end


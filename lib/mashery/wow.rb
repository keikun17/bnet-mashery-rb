module Mashery
  class WOW < Mashery::API
    def url
      super + "wow/"
    end
  end
end

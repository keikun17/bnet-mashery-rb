module Bnet
  class WOW < Bnet::API
    def url
      super + "wow/"
    end
  end
end

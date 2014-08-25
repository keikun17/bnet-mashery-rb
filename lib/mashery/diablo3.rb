module Mashery
  class Diablo3 < Mashery::API
    attr_accessor :battletag

    def url
      super + "d3/profile/#{self.battletag}/"
    end
  end

end

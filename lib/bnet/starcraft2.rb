module Mashery
  class Starcraft2 < Mashery::API
    def url
      super + "sc2/"
    end
  end
end

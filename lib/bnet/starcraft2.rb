module Bnet
  class Starcraft2 < Bnet::API
    def url
      super + "sc2/"
    end
  end
end

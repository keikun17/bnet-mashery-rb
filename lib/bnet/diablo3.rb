module Bnet
  class Diablo3 < Bnet::API
    attr_accessor

    def url
      super + "d3/"
    end

  end

end

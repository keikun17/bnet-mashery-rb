module Mashery
  class Diablo3 < Mashery::API
    attr_accessor

    def url
      super + "d3/"
    end

  end

end

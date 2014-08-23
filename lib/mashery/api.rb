module Mashery
  class API
    def initialize(args={})
      @region = args[:region].downcase if args[:region]
    end

    def region=(region)
      @region = region
    end

    def region
      @region
    end

    def url
      "https://#{region}.api.battle.net/"
    end

  end
end

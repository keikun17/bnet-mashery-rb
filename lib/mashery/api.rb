module Mashery
  class API
    # FIXME : Remove :secret and get the API to append
    # the :key param to the end of each 'get' call
    attr_accessor :region, :secret, :key

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def url
      "https://#{region}.api.battle.net/"
    end

  end
end

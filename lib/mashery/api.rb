module Mashery
  class API
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

module Bnet
  class API
    # FIXME : get the API to append the :key param to the end of each 'get' call
    attr_accessor :region

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def url
      "https://#{region}.api.battle.net/"
    end

    def self.valid_call?(status, response)
      status == ['200', 'OK'] && response["code"] != 'NOTFOUND'
    end

  end
end

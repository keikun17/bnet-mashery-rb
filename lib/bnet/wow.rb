module Bnet
  class WOW < Bnet::API
    def url
      super + "wow/"
    end

    def scoped(scope, args ={})
      api_key = args[:api_key] || Bnet.configuration.api_key
      locale = args[:locale] || 'en_US'
      realm = args[:realm]
      name = args[:name]

      call_url = url + "character/#{realm}/#{name}?fields=#{scope}&locale=#{locale}&apikey=#{api_key}"

      begin
        data = open(call_url)
        raw_response = JSON.parse(data.read)

        if data.status == ['200', 'OK'] && raw_response["code"] != 'NOTFOUND'
          raw_response
        else
          raw_response = {}
        end

      rescue OpenURI::HTTPError => e
        raw_response = {}
      end

      return raw_response
    end

  end
end

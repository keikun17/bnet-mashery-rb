class Mashery::WOW::Data::Base < Mashery::BnetResource
  # Query Battlenet API for the the data based on the subclass's scope
  #
  # Hash Params:
  #   :region          - (e.g. 'us', 'ea')
  #   :name            - String name of the toon
  #   :realm           - String name of the server the character is on (String)
  #   :locale          - String locale (defaults to 'en_US')
  #   :api_key         - String api key
  #
  # Example : If a character named 'AlexeiStukov' is on 'DragonMaw' 'US' server
  def self.find_all(args)
    region = args.delete(:region)
    api_key    = args.delete(:api_key) || Mashery::configuration.api_key
    locale     = args.delete(:locale) || 'en_US'

    base_api = Mashery::WOW.new(region: region)
    call_url = base_api.url + 'data/' + scopes[:url] + "?locale=#{locale}&apikey=#{api_key}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if Mashery::API.valid_call?(data.status, raw_response)
        collection = collection_from_api(raw_response)
      else
        collection = []
      end


    rescue OpenURI::HTTPError => e
      collection = []
    end

    return collection
  end

  private

  def self.collection_from_api(response_collection)
    response_collection[scopes[:collection_root]].collect do |attrs|
      from_api(attrs)
    end
  end

  def self.url(collection_scope)
    "#{Mashery::WOW.url}/data/#{collection_scope}"
  end

  def self.scopes
    self::SCOPES
  end

end

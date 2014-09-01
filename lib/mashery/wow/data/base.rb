class Mashery::WOW::Data::Base

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # Query Battlenet API for the the data based on the subclass's scope
  #
  # Hash Params:
  #   :region          - (e.g. 'us', 'ea')
  #   :name            - String name of the toon
  #   :realm           - String name of the server the character is on (String)
  #   :locale          - String locale (defaults to 'en_US')
  #   :key             - String api key
  #
  # Example : IF a character named 'AlexeiStukov' is on 'DragonMaw' 'US' server
  def self.find_all(args)
    region = args.delete(:region)
    key    = args.delete(:key)
    locale     = args.delete(:locale) || 'en_US'

    base_api = Mashery::WOW.new(region: region)
    call_url = base_api.url + 'data/' + scopes[:url] + "?locale=#{locale}&apikey=#{key}"

    begin
      data = open(call_url)
      parsed_response = JSON.parse(data.read)

      if Mashery::API.valid_call?(data.status, parsed_response)
        collection = collection_from_api(parsed_response)
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

  def self.params_mapping
    self::PARAMS_MAPPING
  end

  def self.from_api(raw_hash)
    new_hash = {}
    association_hash ||= {}
    other_attributes ||= {}

    # NOTE common tasks below -- marker for easier method extraction
    params_mapping.each do |old_key, new_key|
      if raw_hash.has_key?(old_key)
        new_hash[new_key] = raw_hash[old_key]
      end
    end

    new_hash.merge!(association_hash)
    new_hash.merge!(other_attributes)
    new(new_hash)
    # NOTE end of common tasks
  end
end

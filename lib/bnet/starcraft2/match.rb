class Bnet::Starcraft2::Match < Bnet::BnetResource
  attr_accessor :map, :match_type, :decision, :speed, :date, :raw_attributes

  PARAMS_MAPPING = {
    "map" => :map,
    "type" => :match_type,
    "decision" => :decision,
    "speed" => :speed,
    "date" => :date
  }

  def self.all(profile, args = {})
    profile_id = profile.profile_id
    name = profile.name
    realm = profile.realm || '1'
    locale = args[:locale] || 'en_US'
    api_key  = args[:api_key] || Bnet.configuration.api_key

    client = Bnet::Starcraft2.new(region: profile.region)
    call_url = client.url + "profile/#{profile_id}/#{realm}/#{name}/matches?apikey=#{api_key}&locale=#{locale}"

    begin
      data = open(call_url)
      raw_collection_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_collection_response)
        matches = raw_collection_response["matches"].collect do |raw_response|
          match = from_api(raw_response)
          match
        end
      else
        matches = []
      end

    rescue OpenURI::HTTPError => e
      matches = []
    end

    return matches

  end

  def self.from_api(raw_response)
    match = super(raw_response)
    match.raw_attributes = raw_response
    match
  end
end

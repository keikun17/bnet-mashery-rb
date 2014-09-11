class Bnet::Starcraft2::Ladder < Bnet::BnetResource
  attr_accessor :raw_attributes, :characters, :ladder_name, :ladder_id,
    :division, :rank, :league, :matchmaking_queue, :wins, :losses

  #TODO make character object for :characters

  PARAMS_MAPPING = {
    "ladderName"        => :ladder_name,
    "ladderId"          => :ladder_id,
    "division"          => :division,
    "rank"              => :rank,
    "league"            => :league,
    "matchMakingQueue" => :matchmaking_queue,
    "wins"              => :wins,
    "losses"            => :losses
  }


  def self.find_current(profile, args = {})
    profile_id = profile.profile_id
    name = profile.name
    realm = profile.realm || '1'
    locale = args[:locale] || 'en_US'
    api_key  = args[:api_key] || Bnet.configuration.api_key

    client = Bnet::Starcraft2.new(region: profile.region)
    call_url = client.url + "profile/#{profile_id}/#{realm}/#{name}/ladders?apikey=#{api_key}&locale=#{locale}"

    begin
      data = open(call_url)
      raw_collection_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_collection_response)

        ladders = raw_collection_response["currentSeason"].collect do |raw_ladder_character_response|
          raw_characters = raw_ladder_character_response["characters"]
          raw_ladders = raw_ladder_character_response["ladder"].collect do |raw_ladder| 
            ladder = from_api(raw_ladder)
            ladder.characters = raw_characters
            ladder
          end

          raw_ladders
        end

        ladders.flatten!

      else
        ladders = []
      end

    rescue OpenURI::HTTPError => e
      ladders = []
    end

    return ladders

  end

  def self.find_previous(profile, args ={} )
    profile_id = profile.profile_id
    name = profile.name
    realm = profile.realm || '1'
    locale = args[:locale] || 'en_US'
    api_key  = args[:api_key] || Bnet.configuration.api_key

    client = Bnet::Starcraft2.new(region: profile.region)
    call_url = client.url + "profile/#{profile_id}/#{realm}/#{name}/ladders?apikey=#{api_key}&locale=#{locale}"

    begin
      data = open(call_url)
      raw_collection_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_collection_response)

        ladders = raw_collection_response["previousSeason"].collect do |raw_ladder_character_response|
          raw_characters = raw_ladder_character_response["characters"]
          raw_ladders = raw_ladder_character_response["ladder"].collect do |raw_ladder| 
            ladder = from_api(raw_ladder)
            ladder.characters = raw_characters
            ladder
          end

          raw_ladders
        end

        ladders.flatten!

      else
        ladders = []
      end

    rescue OpenURI::HTTPError => e
      ladders = []
    end

    return ladders

  end

end

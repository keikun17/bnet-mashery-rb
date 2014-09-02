# TODO: Associations for career, current_season
class Mashery::Starcraft2::Profile < Mashery::BnetResource

  attr_accessor :profile_id, :realm, :display_name, :clan_name, :clan_tag,
    :achievement_points, :swarm_level, :terran_level, :zerg_level,
    :protoss_level, :acievement_points

  PARAMS_MAPPING = {
      "id" => :profile_id,
      "realm" =>  :realm,
      "displayName" => :display_name,
      "clanName" => :clan_name,
      "clanTag" => :clan_tag,
      "career" => :career
    }

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # Query Battlenet API for the SC2 profile recordand create an instance of an
  # SC2 Profile.
  #
  # Hash Params:
  #   :realm      - (defaults to '1')
  #   :profile_id - ID (Honestly i do not know why Blizzard still needs this if
  #                 localized Battletag is unique enough)
  #   :name       - Just the name string in the Battle tag.
  #   :locale     - (defaults to 'en_US')
  #   :api_key        - the api key
  #
  # Example: If US account 'Playerone#1309' the profile can be accessible via
  # web from 'http://us.battle.net/sc2/en/profile/2143215/1/PlayerOne/'
  #
  #   find(region: 'us', id: 2143215, name: 'PlayerOne', api_key: your_api_key)
  def self.find args
    region     = args.delete(:region)
    profile_id = args.delete(:profile_id)
    name       = args.delete(:name)
    realm      = args.delete(:realm) || '1'
    locale     = args.delete(:locale) || 'en_US'
    api_key        = args.delete(:api_key) || Mashery.configuration.api_key

    base_api = Mashery::Starcraft2.new(region: region)
    call_url = base_api.url + "profile/#{profile_id}/#{realm}/#{name}/?locale=#{locale}&apikey=#{api_key}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if Mashery::API.valid_call?(data.status, raw_response)
        bnet_object = from_api(raw_response)
      else
        bnet_object = nil
      end

    rescue OpenURI::HTTPError => e
      bnet_object = nil
    end

    return bnet_object

  end

  def career
    @career ||= []
  end

  def self.from_api(response)
    bnet_resource = super(response)
    if bnet_resource && response["achievements"]
      bnet_resource.achievement_points = response["achievements"]["points"]["totalPoints"]
    end

    if bnet_resource && response["swarmLevels"]
      bnet_resource.swarm_level   = response["swarmLevels"]["level"]
      bnet_resource.terran_level  = response["swarmLevels"]["terran"]["level"]
      bnet_resource.protoss_level = response["swarmLevels"]["protoss"]["level"]
      bnet_resource.zerg_level    = response["swarmLevels"]["zerg"]["level"]
    end

    bnet_resource
  end
end

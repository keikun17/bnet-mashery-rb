# TODO: Associations for career, current_season
class Bnet::Starcraft2::Profile < Bnet::BnetResource

  attr_accessor :profile_id, :realm, :name, :clan_name, :clan_tag,
    :achievement_points, :swarm_level, :terran_level, :zerg_level,
    :protoss_level, :acievement_points, :career, :region,
    :raw_attributes

  PARAMS_MAPPING = {
      "id" => :profile_id,
      "realm" =>  :realm,
      "displayName" => :name,
      "clanName" => :clan_name,
      "clanTag" => :clan_tag
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
  #   Required
  #     :realm         - (required but defaults to '1')
  #     :profile_id    - ID (Honestly i do not know why Blizzard still needs this if
  #                      localized Battletag is unique enough)
  #     :name  - Just the name string in the Battle tag.
  #
  #   Optional
  #     :locale        - (defaults to 'en_US')
  #     :api_key       - the api key
  #
  # Example: If US account 'Playerone#1309' the profile can be accessible via
  # web from 'http://us.battle.net/sc2/en/profile/2143215/1/PlayerOne/'
  #
  #   find(region: 'us', profile_id: 2143215, name: 'PlayerOne')
  #
  # Returns a Profile object with the following attributes
  #
  #      :profile_id, :realm, :name, :clan_name, :clan_tag,
  #      :achievement_points, :swarm_level, :terran_level, :zerg_level,
  #      :protoss_level, :acievement_points
  def self.find args
    region     = args[:region]
    profile_id = args[:profile_id]
    name       = args[:name]
    realm      = args[:realm] || '1'
    locale     = args[:locale] || 'en_US'
    api_key        = args[:api_key] || Bnet.configuration.api_key

    base_api = Bnet::Starcraft2.new(region: region)
    call_url = base_api.url + "profile/#{profile_id}/#{realm}/#{name}/?locale=#{locale}&apikey=#{api_key}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_response)
        bnet_object = from_api(raw_response)
        bnet_object.raw_attributes = raw_response
        bnet_object.region = region
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

  def matches
    @matches ||= Bnet::Starcraft2::Match.all(self)
  end

  def ladders
    # @ladders ||=
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

    assign_career_from_raw_career(bnet_resource, response["career"]) if response["career"]

    bnet_resource
  end

  private

  def self.assign_career_from_raw_career(profile, raw_career)
    profile.career = Bnet::Starcraft2::Career.from_api(raw_career)
    return profile
  end

end

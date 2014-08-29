class Mashery::Starcraft2::Profile

  attr_accessor :profile_id, :realm, :display_name, :clan_name, :clan_tag,
    :achievement_points, :swarm_level, :terran_level, :zerg_level,
    :protoss_level, :acievement_points

    # TODO: Associations for career, current_season
  #
  def career
    @career ||= []
  end
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
  #   :key        - the api key
  #
  # Example: If US account 'Playerone#1309' the profile can be accessible via
  # web from 'http://us.battle.net/sc2/en/profile/2143215/1/PlayerOne/'
  #
  #   find(region: 'us', id: 2143215, name: 'PlayerOne', key: your_api_key)
  def self.find args
    region     = args.delete(:region)
    profile_id = args.delete(:profile_id)
    name       = args.delete(:name)
    realm      = args.delete(:realm) || '1'
    locale     = args.delete(:locale) || 'en_US'
    key        = args.delete(:key)

    base_api = Mashery::Starcraft2.new(region: region, key: key)
    call_url = base_api.url + "profile/#{profile_id}/#{realm}/#{name}/?locale=#{locale}&apikey=#{key}"

    begin
      data = open(call_url)
      parsed_response = JSON.parse(data.read)

      if data.status == ['200', 'OK'] && parsed_response["code"] != 'NOTFOUND'
        bnet_object = from_api(parsed_response)
      else
        bnet_object = nil
      end

    rescue OpenURI::HTTPError => e
      bnet_object = nil
    end

    return bnet_object

  end

  def self.from_api(response)
    new_hash = {}
    association_hash ||= {}
    other_attributes ||= {}

    if response["achievements"]
      achievement_points = response["achievements"]["points"]["totalPoints"]
      other_attributes.merge!({achievement_points: achievement_points})
    end

    if response["swarmLevels"]
      other_attributes.merge!({
        :swarm_level   => response["swarmLevels"]["level"],
        :terran_level  => response["swarmLevels"]["terran"]["level"],
        :protoss_level => response["swarmLevels"]["protoss"]["level"],
        :zerg_level    => response["swarmLevels"]["zerg"]["level"]
      })
    end


    # NOTE common tasks below -- marker for easier method extraction
    params_mapping.each do |old_key, new_key|
      if response.has_key?(old_key)
        new_hash[new_key] = response[old_key]
      end
    end

    new_hash.merge!(association_hash)
    new_hash.merge!(other_attributes)
    new(new_hash)
    # NOTE end of common tasks
  end

  private

  def self.params_mapping
    {
      "id" => :profile_id,
      "realm" =>  :realm,
      "displayName" => :display_name,
      "clanName" => :clan_name,
      "clanTag" => :clan_tag,
      "career" => :career
    }
  end

end

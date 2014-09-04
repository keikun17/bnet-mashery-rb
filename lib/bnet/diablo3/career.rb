class Bnet::Diablo3::Career < Bnet::BnetResource

  attr_accessor :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    :progression, :region

  PARAMS_MAPPING =  {
      "lastHeroPlayed" => :last_hero_played,
      "lastUpdated" => :last_updated,
      "kills" => :kills,
      "timePlayed" => :time_played,
      "fallenHeroes" => :fallen_heroes,
      "paragonLevel" => :paragon_level,
      "paragonLevelHardcore" => :paragon_level_hardcore,
      "battleTag" => :battle_tag,
      "progression" => :progression
  }

  def battle_tag
    @battle_tag.gsub('-', '#')
  end

  # Perform a query for the Diablo 3 character profile.
  #
  # Arguments
  #   Required
  #     :battle_tag - Player Battletag (ex. PlayerOne#1309)
  #     :region     - Account region (ex. 'us')
  #   Optional
  #     :locale     - String locale (default: 'en_US')
  #     :api_key    - String API key
  #
  # Example
  #
  # Bnet::Diablo3.find(battle_tag: 'PlayerOne#1309', region: 'us')
  #
  # Returns a Career object with the following attributes
  #
  #    :heroes, :last_hero_played, :last_updated, :kills, :time_played,
  #    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
  #    :progression, :region
  #
  # Note : Autoloads the associated hero records from the Hero API as well
  def self.find args
    battle_tag = args[:battle_tag].gsub('#', '-')
    region     = args[:region]
    api_key    = args[:api_key] || Bnet.configuration.api_key
    locale     = args.delete(:locale) || 'en_US'

    base_api = Bnet::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/?apikey=#{api_key}&locale=#{locale}"

    # NOTE common tasks below - marker for easier method extraction
    response = JSON.parse( URI.parse(call_url).read )

    data = open(call_url)
    raw_response = JSON.parse(data.read)

    if Bnet::API.valid_call?(data.status, raw_response)
      career = from_api(raw_response)
    else
      career = nil
    end
    # NOTE end of common tasks

    if career
      career.battle_tag = battle_tag
      career.region = region

      # Association tasks (TODO: convert to hook)
      if raw_response["heroes"]
        heroes = response["heroes"].collect do |raw_hero_attrs|
          hero = Bnet::Diablo3::Hero.from_api(raw_hero_attrs)
          hero.career = career
          hero.battle_tag = career.battle_tag
          hero.region = career.region
          hero.reload
          hero
        end

        career.heroes = heroes
      end
      # End of association tasks

    end

    return career
  end


end

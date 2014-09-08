class Bnet::Diablo3::Career < Bnet::BnetResource

  attr_accessor :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    :progression, :region, :raw_attributes

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
  # Bnet::Diablo3::Career.find(battle_tag: 'PlayerOne#1309', region: 'us')
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
    locale     = args[:locale] || 'en_US'

    base_api = Bnet::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/?apikey=#{api_key}&locale=#{locale}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_response)
        career = from_api(raw_response)
        career.raw_attributes = raw_response
        career.region = region

        assign_heroes_from_raw_heroes(career, raw_response["heroes"]) if raw_response["heroes"]
      else
        career = nil
      end

    rescue OpenURI::HTTPError => e
      career = nil
    end

    return career
  end

  def self.from_api(response)
    career = super(response)
    career.raw_attributes = response
    return career
  end

  private

  def self.assign_heroes_from_raw_heroes(career, raw_heroes)
    career.heroes = raw_heroes.collect do |raw_hero_attrs|
      hero = Bnet::Diablo3::Hero.from_api(raw_hero_attrs)
      hero.career = career
      hero.battle_tag = career.battle_tag
      hero.region = career.region
      hero.reload
      hero
    end

    return career
  end

end

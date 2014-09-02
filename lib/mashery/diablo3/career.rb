class Mashery::Diablo3::Career < Mashery::BnetResource

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

  def self.find args
    battle_tag = args[:battle_tag].gsub('#', '-')
    region = args[:region]
    api_key = args[:api_key] || Mashery.configuration.api_key

    base_api = Mashery::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/?apikey=#{api_key}"

    # NOTE common tasks below - marker for easier method extraction
    response = JSON.parse( URI.parse(call_url).read )

    data = open(call_url)
    raw_response = JSON.parse(data.read)

    if Mashery::API.valid_call?(data.status, raw_response)
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
          hero = Mashery::Diablo3::Hero.from_api(raw_hero_attrs)
          hero.career = career
          hero.battle_tag = career.battle_tag
          hero.region = career.region
          hero
        end

        career.heroes = heroes
      end
      # End of association tasks

    end

    return career
  end


end

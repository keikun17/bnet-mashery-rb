class Mashery::Diablo3::Career

  attr_accessor :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    :progression

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

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
    parsed_response = JSON.parse(data.read)

    if data.status == ['200', 'OK'] && parsed_response["code"] != "NOTFOUND"
      career = from_api(parsed_response)
    else
      career = nil
    end

    return career
  end

  def self.from_api(response)
    # NOTE common tasks below -- marker for easier method extraction
    new_hash = {}
    association_hash ||= {}
    other_attributes ||= {}

    if response["heroes"]
      heroes = response["heroes"].collect do |raw_hero_attrs|
        Mashery::Diablo3::Hero.from_api(raw_hero_attrs)
      end

      association_hash = {heroes: heroes}
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
  end
end

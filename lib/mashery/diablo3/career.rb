class Mashery::Diablo3::Career

  attr_accessor :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    :progression

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def self.find args
    battletag = args.delete(:battletag)
    region = args.delete(:region)
    key = args.delete(:key)
    secret = args.delete(:secret)

    base_api = Mashery::Diablo3.new(region: region, secret: secret)
    call_url = base_api.url + "peofile/#{battletag}?key=#{key}"
    response = URI.parse(call_url).read
  end

  private

  def career_params_mapping
    {
      "heroes" => :heroes,
      "lastHeroPlayed" => :last_hero_played,
      "lastUpdated" => :last_updated,
      "kills" => :kills,
      "timePlayed" => :time_played,
      "fallenHeroes" => :fallen_heroesj,
      "paragonLevel" => :paragon_level,
      "paragonLevelHardcore" => :paragon_level_hardcore,
      "battleTag" => :battle_tag,
      "progression" => :progression 
    }
  end
end

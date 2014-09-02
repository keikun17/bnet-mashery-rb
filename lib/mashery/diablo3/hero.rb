class Mashery::Diablo3::Hero < Mashery::BnetResource

  attr_accessor :paragon_level, :seasonal, :name, :hero_id,
    :level, :hardcore, :gender, :dead, :hero_class, :last_update,
    :active_skills, :passive_skills, :region, :battle_tag, :career

    PARAMS_MAPPING = {
      "paragonLevel" => :paragon_level,
      "seasonal" => :seasonal,
      "name" => :name,
      "id" => :hero_id,
      "level" => :level,
      "hardcore" => :hardcore,
      "gender" => :gender,
      "dead" => :dead,
      "class" => :hero_class,
      "last-updated" => :last_updated
    }

  # Create an instance by passing in the args from the response
  def self.from_api(response)
    bnet_resource = super(response)

    if bnet_resource && response["skills"]
      bnet_resource.active_skills = response["skills"]["active"].collect do |active|
        Mashery::Diablo3::Skill.new(name: active["skill"]["name"],
                                    rune: active["rune"]["name"])
      end

      bnet_resource.passive_skills = response["skills"]["passive"].collect do |passive|
        Mashery::Diablo3::Skill.new(name: passive["skill"]["name"])
      end
    end

    bnet_resource
  end

  def active_skills
    @active_skills ||= []
  end

  def passive_skills
    @passive_skills ||= []
  end

  def reload
    find(battle_tag: battle_tag, region: region, hero_id: hero_id)
  end

  # Query the Diablo 3 api to find and create an instance of a hero
  def self.find args
    battle_tag = args[:battle_tag]
    region = args[:region]
    hero_id = args[:hero_id]
    api_key = args[:api_key] || Mashery.configuration.api_key

    if battle_tag
      battle_tag.gsub!('#', '-')
    end

    base_api = Mashery::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/hero/#{hero_id}?apikey=#{api_key}"

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

end

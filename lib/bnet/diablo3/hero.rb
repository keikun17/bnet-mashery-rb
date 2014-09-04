class Bnet::Diablo3::Hero < Bnet::BnetResource

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


  def active_skills
    @active_skills ||= []
  end

  def passive_skills
    @passive_skills ||= []
  end

  def battle_tag
    @battle_tag.gsub("-", "#")
  end

  #TODO Extract finder_args to a method then move this `reload ` method to super
  #class
  def reload
    finder_args = {battle_tag: battle_tag, region: region, hero_id: hero_id}
    fetched_record = self.class.find(finder_args)
    fetched_record.instance_variables.each do |ivar|
      self.instance_variable_set(ivar, fetched_record.instance_variable_get(ivar))
    end
  end

  # Query the Diablo 3 api to find and create an instance of a hero
  def self.find args
    battle_tag = args[:battle_tag]
    region = args[:region]
    hero_id = args[:hero_id]
    api_key = args[:api_key] || Bnet.configuration.api_key

    if battle_tag
      battle_tag.gsub!('#', '-')
    end

    base_api = Bnet::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/hero/#{hero_id}?apikey=#{api_key}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if Bnet::API.valid_call?(data.status, raw_response)
        bnet_object = from_api(raw_response)
      else
        bnet_object = nil
      end

    rescue OpenURI::HTTPError => e
      bnet_object = nil
    end

    return bnet_object
  end

  # Create an instance by passing in the args from the response
  def self.from_api(response)
    bnet_resource = super(response)

    if bnet_resource && response["skills"]
      bnet_resource.active_skills = response["skills"]["active"].collect do |active|

        skill = Bnet::Diablo3::Skill.new
        if active["skill"]
          skill.name = active["skill"]["name"]
        end
        if active["rune"]
          skill.rune = active["rune"]["name"]
        end

        skill

      end

      bnet_resource.passive_skills = response["skills"]["passive"].collect do |passive|
        skill =  Bnet::Diablo3::Skill.new
        if passive["skill"]
          skill.name = passive["skill"]["name"]
        end
        skill
      end
    end

    bnet_resource
  end

end

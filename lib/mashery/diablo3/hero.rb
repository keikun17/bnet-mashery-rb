class Mashery::Diablo3::Hero

  attr_accessor :paragon_level, :seasonal, :name, :hero_id,
    :level, :hardcore, :gender, :dead, :hero_class, :last_update,
    :active_skills, :passive_skills

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # Create an instance by passing in the args from the response
  def self.from_api(response)

    if response["skills"]
      active_skills = response["skills"]["active"].collect do |active|
        Mashery::Diablo3::Skill.new(name: active["skill"]["name"],
                                    rune: active["rune"]["name"])
      end

      passive_skills = response["skills"]["passive"].collect do |passive|
        Mashery::Diablo3::Skill.new(name: passive["skill"]["name"])
      end

      association_hash = {passive_skills: passive_skills, active_skills: active_skills}
    end

    # NOTE common tasks below -- marker for easier method extraction
    new_hash = {}
    association_hash ||= {}
    params_mapping.each do |old_key, new_key|
      if response.has_key?(old_key)
        new_hash[new_key] = response[old_key]
      end
    end

    new_hash.merge!(association_hash)
    new(new_hash)
    # NOTE end of common tasks
  end

  # TODO : Check if we still need this
  def active_skills
    @active_skills ||= []
  end

  # TODO : Check if we still need this
  def passive_skills
    @passive_skills ||= []
  end

  # Query the Diablo 3 api to find and create an instance of a hero
  def self.find args
    battletag = args.delete(:battletag)
    region = args.delete(:region)
    key = args.delete(:key)
    secret = args.delete(:secret)
    hero_id = args.delete(:hero_id)

    base_api = Mashery::Diablo3.new(region: region, secret: secret)
    call_url = base_api.url + "profile/#{battletag}/hero/#{hero_id}?apikey=#{key}"

    begin
      data = open(call_url)
      parsed_response = JSON.parse(data.read)

      if Mashery::API.valid_call?(data.status, parsed_response)
        bnet_object = from_api(parsed_response)
      else
        bnet_object = nil
      end

    rescue OpenURI::HTTPError => e
      bnet_object = nil
    end

    return bnet_object
  end

  private

  def self.params_mapping
    {
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
  end
end

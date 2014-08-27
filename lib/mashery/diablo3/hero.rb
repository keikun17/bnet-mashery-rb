class Mashery::Diablo3::Hero

  attr_accessor :paragon_level, :seasonal, :name, :hero_id,
    :level, :hardcore, :gender, :dead, :hero_class, :last_update

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # Create an instance by passing in the args from the response
  def self.from_api(response)
    new_hash = {}
    response.each do |k,v|
      new_key = hero_params_mapping[k]
      new_hash[new_key] = v
    end
    new(new_hash)
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

    data = open(call_url)

    if data.status == ['200', 'OK']
      hero = from_api(JSON.parse(data.read))
    else
      hero = nil
    end

    return hero
  end

  private

  def self.hero_params_mapping
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

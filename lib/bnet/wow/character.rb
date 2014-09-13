class Bnet::WOW::Character < Bnet::BnetResource

  attr_accessor :name, :realm, :battlegroup, :class, :race, :gender, :level,
    :achievement_points, :total_honorable_kills, :calc_class, :region,
    :raw_attributes

  # Query Battlenet API for the character profile
  #
  # Hash Params:
  #   Required
  #     :region          - (e.g. 'us', 'ea')
  #     :name            - String name of the toon
  #     :realm           - String name of the server the character is on (String)
  #   Optional
  #     :locale          - String locale (defaults to 'en_US')
  #     :api_key         - String api key
  #
  # Example : IF a character named 'AlexeiStukov' is on 'DragonMaw' 'US' server
  #
  #   Bnet::WOW::Character.find(region: 'us', name: 'AlexeiStukov', realm: 'Dragonmaw')
  #
  # Returns a Character with the following attributes
  #
  #   :name, :realm, :battlegroup, :class, :race, :gender, :level,
  #   :achievement_points, :total_honorable_kills, :calc_class
  def self.find args
    region     = args[:region]
    realm      = args[:realm]
    name       = args[:name]
    locale     = args[:locale] || 'en_US'
    api_key    = args[:api_key] || Bnet.configuration.api_key

    client = Bnet::WOW.new(region: region)
    call_url = client.url + "character/#{realm}/#{name}?locale=#{locale}&apikey=#{api_key}"

    begin
      data = open(call_url)
      raw_response = JSON.parse(data.read)

      if data.status == ['200', 'OK'] && raw_response["code"] != 'NOTFOUND'
        bnet_object = from_api(raw_response)
        bnet_object.region = region
      else
        bnet_object = nil
      end

    rescue OpenURI::HTTPError => e
      bnet_object = nil
    end

    return bnet_object
  end

  def self.from_api(raw_response)
    character = super(raw_response)
    character.raw_attributes = raw_response
    character
  end

  def gender
    case @gender
    when 0
      'Female'
    when 1
      'Male'
    end
  end

  def achievements
    return @achievements if @achievements
    client = Bnet::WOW.new(region: region)
    @achievements = client.scoped('achievements', realm: realm, name: name)
  end

  def appearance
    return @appearance if @appearance
    client = Bnet::WOW.new(region: region)
    @appearance = client.scoped('appearance', realm: realm, name: name)
  end

  def feed
    return @feed if @feed
    client = Bnet::WOW.new(region: region)
    @feed = client.scoped('feed', realm: realm, name: name)
  end

  def guild
    return @guild if @guild
    client = Bnet::WOW.new(region: region)
    @guild = client.scoped('guild', realm: realm, name: name)
  end

  def hunter_pets
    return @hunter_pets if @hunter_pets
    client = Bnet::WOW.new(region: region)
    @hunter_pets = client.scoped('hunterPets', realm: realm, name: name)
  end

  def items
    return @items if @items
    client = Bnet::WOW.new(region: region)
    @items = client.scoped('items', realm: realm, name: name)
  end

  def mounts
    return @mounts if @mounts
    client = Bnet::WOW.new(region: region)
    @mounts = client.scoped('mounts', realm: realm, name: name)
  end

  def pets
    return @pets if @pets
    client = Bnet::WOW.new(region: region)
    @pets = client.scoped('pets', realm: realm, name: name)
  end

  def pet_slots
    return @pet_slots if @pet_slots
    client = Bnet::WOW.new(region: region)
    @pet_slots = client.scoped('petSlots', realm: realm, name: name)
  end

  def progression
    return @progression if @progression
    client = Bnet::WOW.new(region: region)
    @progression = client.scoped('progression', realm: realm, name: name)
  end

  def pvp
    return @pvp if @pvp
    client = Bnet::WOW.new(region: region)
    @pvp = client.scoped('pvp', realm: realm, name: name)
  end
  private

  def self.params_mapping
    {
      "name" => :name,
      "realm" => :realm,
      "battlegroup" => :battlegroup,
      "class" => :class,
      "race" => :race,
      "gender" => :gender,
      "level" => :level,
      "achievement_points" => :achievement_points,
      "calc_class" => :calc_class,
      "total_honorable_kills" => :total_honorable_kills
    }
  end

end

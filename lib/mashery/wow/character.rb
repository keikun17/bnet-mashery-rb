class Mashery::WOW::Character < Mashery::BnetResource

  attr_accessor :name, :realm, :battlegroup, :class, :race, :gender, :level,
    :achievement_points, :total_honorable_kills, :calc_class

  # Query Battlenet API for the character profile
  #
  # Hash Params:
  #   :region          - (e.g. 'us', 'ea')
  #   :name            - String name of the toon
  #   :realm           - String name of the server the character is on (String)
  #   :locale          - String locale (defaults to 'en_US')
  #   :key             - String api key
  #
  # Example : IF a character named 'AlexeiStukov' is on 'DragonMaw' 'US' server
  def self.find args
    region     = args.delete(:region)
    realm      = args.delete(:realm)
    name       = args.delete(:name)
    locale     = args.delete(:locale) || 'en_US'
    key        = args.delete(:key)

    base_api = Mashery::WOW.new(region: region, key: key)
    call_url = base_api.url + "character/#{realm}/#{name}?locale=#{locale}&apikey=#{key}"

    begin
      data = open(call_url)
      parsed_response = JSON.parse(data.read)

      if data.status == ['200', 'OK'] && parsed_response["code"] != 'NOTFOUND'
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

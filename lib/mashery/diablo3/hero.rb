class Mashery::Diablo3::Hero

  attr_accessor :paragon_level, :seasonal, :name, :hero_id,
    :level, :hardcore, :gender, :dead, :class, :last_update

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def self.from_api(response)
    new_hash = {}
    response.each do |k,v|
      new_key = hero_params_mapping[k]
      new_hash[new_key] = v
    end
    new(new_hash)
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
      "class" => :class,
      "last-updated" => :last_updated
    }
  end
end

class Bnet::Diablo3::Hero < Bnet::BnetResource

  attr_accessor :paragon_level, :seasonal, :name, :hero_id,
    :level, :hardcore, :gender, :dead, :hero_class, :last_update,
    :active_skills, :passive_skills, :region, :battle_tag, :career,
    :items,

    # stats
    :life, :damage, :attack_speed, :armor, :strength, :dexterity, :vitality,
    :intelligence, :physical_resist, :fire_resist, :cold_resist,
    :lightning_resist, :poison_resist, :arcane_resist, :crit_damage,
    :block_chance, :block_amount_min, :block_amount_max, :damage_increase,
    :crit_chance, :damage_reduction, :thorns, :life_steal, :life_per_kill,
    :gold_find, :magic_find, :life_on_Hit, :primary_resource,
    :secondary_resource

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


  # TODO:Implement
  # def career
  #   @career = #DO
  # end

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

  # Perform a query for the D3 career's hero
  #
  # Arguments
  #   Required
  #     :battle_tag - Player Battletag (ex. PlayerOne#1309)
  #     :region     - Account region (ex. 'us')
  #     :hero_id    - You can get this from an existing Career object
  #                   or from the website url when you view a hero
  #   Optional
  #     :locale     - String locale (default: 'en_US')
  #     :api_key    - String API key
  #
  # Example
  #
  # Bnet::Diablo3::Hero.find(battle_tag: 'PlayerOne-1309', region: 'us', hero_id: 1304986)
  #
  # Returns a Hero object with the following attributes
  #
  #  :paragon_level, :seasonal, :name, :hero_id,
  #  :level, :hardcore, :gender, :dead, :hero_class, :last_update,
  #  :active_skills, :passive_skills, :region, :battle_tag, :career
  def self.find args
    battle_tag = args[:battle_tag]
    region     = args[:region]
    hero_id    = args[:hero_id]
    locale     = args[:locale] || 'en_US'
    api_key    = args[:api_key] || Bnet.configuration.api_key

    if battle_tag
      battle_tag.gsub!('#', '-')
    end

    base_api = Bnet::Diablo3.new(region: region)
    call_url = base_api.url + "profile/#{battle_tag}/hero/#{hero_id}?apikey=#{api_key}&locale=#{locale}"

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
    hero = super(response)

    if hero && response["skills"]
      hero.active_skills = response["skills"]["active"].collect do |active|

        skill = Bnet::Diablo3::Skill.new
        if active["skill"]
          skill.name = active["skill"]["name"]
        end
        if active["rune"]
          skill.rune = active["rune"]["name"]
        end

        skill

      end

      hero.passive_skills = response["skills"]["passive"].collect do |passive|
        skill =  Bnet::Diablo3::Skill.new
        if passive["skill"]
          skill.name = passive["skill"]["name"]
        end
        skill
      end
    end

    if hero && response["stats"]
      hero.assign_stats_from_raw_stats(response["stats"])
    end

    hero
  end

  def assign_stats_from_raw_stats(raw_stats)
    self.life               = raw_stats["life"]
    self.damage             = raw_stats["damage"]
    self.attack_speed       = raw_stats["attackSpeed"]
    self.armor              = raw_stats["armor"]
    self.strength           = raw_stats["strength"]
    self.dexterity          = raw_stats["dexterity"]
    self.vitality           = raw_stats["vitality"]
    self.intelligence       = raw_stats["intelligence"]
    self.physical_resist    = raw_stats["physicalResist"]
    self.fire_resist        = raw_stats["fireResist"]
    self.cold_resist        = raw_stats["coldResist"]
    self.lightning_resist   = raw_stats["lightningResist"]
    self.poison_resist      = raw_stats["poisonResist"]
    self.arcane_resist      = raw_stats["arcaneResist"]
    self.crit_damage        = raw_stats["critDamage"]
    self.block_chance       = raw_stats["blockChance"]
    self.block_amount_min   = raw_stats["blockAmountMin"]
    self.block_amount_max   = raw_stats["blockAmountMax"]
    self.damage_increase    = raw_stats["damageIncrease"]
    self.crit_chance        = raw_stats["critChance"]
    self.damage_reduction   = raw_stats["damageReduction"]
    self.thorns             = raw_stats["thorns"]
    self.life_steal         = raw_stats["lifeSteal"]
    self.life_per_kill      = raw_stats["lifePerKill"]
    self.gold_find          = raw_stats["goldFind"]
    self.magic_find         = raw_stats["magicFind"]
    self.life_on_Hit        = raw_stats["lifeOnHit"]
    self.primary_resource   = raw_stats["primaryResource"]
    self.secondary_resource = raw_stats["secondaryResource"]
  end

end

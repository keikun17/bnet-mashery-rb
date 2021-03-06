class Bnet::Diablo3::Follower < Bnet::BnetResource
  attr_accessor :follower_type, :level, :raw_attributes,
    :magic_find, :gold_find, :experience_bonus,

    #associations
    :items, :skills

  def self.from_api(follower_type, raw_response)
    follower = new(follower_type: follower_type)
    follower.raw_attributes = raw_response
    follower.level = raw_response["level"]

    assign_items_from_raw_items(follower, raw_response["items"]) if raw_response["items"]
    assign_skills_from_raw_skills(follower, raw_response["skills"]) if raw_response["skills"]

    follower.magic_find = raw_response["stats"]["magicFind"]
    follower.gold_find = raw_response["stats"]["goldFind"]
    follower.experience_bonus =  raw_response["stats"]["experienceBonus"]

    return follower
  end

  private

  def self.assign_items_from_raw_items(follower, raw_items)
    follower.items = raw_items.collect do |location, item_props|
      Bnet::Diablo3::Item.from_api(location, item_props)
    end

    return follower
  end

  def self.assign_skills_from_raw_skills(follower, raw_skills)
    follower.skills = raw_skills.collect do |raw_skill|
      Bnet::Diablo3::Skill.from_api(raw_skill) unless raw_skill.empty?
    end

    follower.skills = follower.skills.compact

    return follower
  end
end

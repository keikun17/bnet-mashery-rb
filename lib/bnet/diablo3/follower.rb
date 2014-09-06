class Bnet::Diablo3::Follower < Bnet::BnetResource
  attr_accessor :follower_type, :level, :raw_attributes,
    :magic_find, :gold_find, :experience_bonus,

    #associations
    :items, :skills

  def self.from_api(follower_type, raw_response)
    follower = new(follower_type: follower_type)
    follower.raw_attributes = raw_response
    follower.level = raw_response["level"]
    # follower.items = raw_response["items"]
    # follower.skills = raw_response["skills"]
    follower.magic_find = raw_response["stats"]["magicFind"]
    follower.gold_find = raw_response["stats"]["goldFind"]
    follower.experience_bonus =  raw_response["stats"]["experienceBonus"]

    return follower
  end

end

class Bnet::Diablo3::Follower
  attr_accessor :follower_type, :level, :raw_attributes,
    :magic_find, :gold_find, :experience_bonus,

    #associations
    :items, :skills
end

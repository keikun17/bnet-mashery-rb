class Bnet::Diablo3::Skill < Bnet::BnetResource

  attr_accessor :name, :rune


  # Ags :
  #      {
  #        "skill" => { name: "", ... },
  #        "rune"  => { name: "", ... }
  #      }
  #
  # Returns:
  #
  # #<Bnet::Diablo3::Skill:0x007fd111396360 @name: "", @rune: "">
  def self.from_api(response)
    skill = new
    skill.name = response['skill']['name']
    skill.rune = response['rune']['name'] if response["rune"]

    return skill
  end

end

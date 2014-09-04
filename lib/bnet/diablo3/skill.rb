class Mashery::Diablo3::Skill < Mashery::BnetResource

  attr_accessor :name, :rune


  # Ags :
  #      {
  #        "skill" => { name: "", ... },
  #        "rune"  => { name: "", ... }
  #      }
  #
  # Returns:
  #
  # #<Mashery::Diablo3::Skill:0x007fd111396360 @name: "", @rune=>
  def self.from_api(response)
    new(name: response['skill']['name'], rune: response['rune']['name'])
  end

end

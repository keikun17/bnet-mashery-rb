class Mashery::Diablo3::Skill

  attr_accessor :name, :rune

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

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

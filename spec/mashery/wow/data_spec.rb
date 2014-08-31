require 'spec_helper'

describe Mashery::WOW::Data do
  it "autoloads WoW's dat modules"
  # expect(Mashery::WOW::Data.autoload?(Mashery::WOW::Data::Base)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battlegroup)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:BattleterRaces)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:BattleterClasses)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:BattleterAchivements)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battleewards)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battlechievements)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battleasses)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battles)).to_not be_nil
  # expect(Mashery::WOW::Data.autoload?(:Battlees)).to_not be_nil

  it "doesn't load other modules" do
    expect(Mashery::WOW::Data.autoload?(:Zoom)).to be_nil
  end

end


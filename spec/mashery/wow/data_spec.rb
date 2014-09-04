require 'spec_helper'

describe Bnet::WOW::Data do
  it "autoloads WoW's dat modules"
  # expect(Bnet::WOW::Data.autoload?(Bnet::WOW::Data::Base)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battlegroup)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:BattleterRaces)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:BattleterClasses)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:BattleterAchivements)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battleewards)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battlechievements)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battleasses)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battles)).to_not be_nil
  # expect(Bnet::WOW::Data.autoload?(:Battlees)).to_not be_nil

  it "doesn't load other modules" do
    expect(Bnet::WOW::Data.autoload?(:Zoom)).to be_nil
  end

end


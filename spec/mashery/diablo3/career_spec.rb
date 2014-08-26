require 'spec_helper'

describe Mashery::Diablo3::Career do

  describe ".new" do
    let(:attrs){
      ["heroes",
       "lastHeroPlayed",
       "lastUpdated",
       "kills",
       "timePlayed",
       "fallenHeroes",
       "paragonLevel",
       "paragonLevelHardcore",
       "battleTag",
       "progression"]
    }
    subject{ described_class.new(attrs)}
    it "Can be initialized" do
      pending
    end
  end

  describe ".find" do
    subject { described_class.find(args) }
    let(:args) do
      {battletag: 'PlayerOne-1306', region: 'us', key: 'any'}
    end

    context "Playertag for the server exists" do
      it { is_expected.to_not be_nil }
    end

    context "Playertag for the server does not exist" do
      it { pending }
    end
  end

end

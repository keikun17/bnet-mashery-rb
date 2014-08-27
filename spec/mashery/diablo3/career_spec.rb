require 'spec_helper'

describe Mashery::Diablo3::Career do

  describe ".from_api" do
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
    subject{ described_class.from_api(attrs)}
    it "is initialized" do
      expect(subject).to be_a_kind_of(described_class)
    end
  end

  describe ".find", vcr: { cassette_name: 'find_diablo_career_player_one '} do
    subject { described_class.find(args) }
    let(:args) do
      {battletag: 'PlayerOne-1309', region: 'us', key: 'wae9fv8fdmav7u4zaxnakc4aph2km3u7'}
    end

    context "Playertag for the server exists" do
      it { is_expected.to_not be_nil }
    end

    context "Playertag for the server does not exist" do
      it { pending }
    end
  end

end

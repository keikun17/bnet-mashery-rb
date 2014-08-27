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

  describe ".find" do
    subject { described_class.find(args) }

    context "Playertag for the server exists" ,vcr: { cassette_name: 'find_diablo_career_player_one '} do
      let(:args) do
        { battletag: 'PlayerOne-1309', region: 'us', key: 'wae9fv8fdmav7u4zaxnakc4aph2km3u7' }
      end
      it { is_expected.to_not be_nil }
    end

    context "Playertag for the server does not exist", vcr: { cassette_name: 'find_diablo_career_doesnt_exist'} do
      let(:args) do
        { battletag: 'DoesntExist-42', region: 'us', key: 'wae9fv8fdmav7u4zaxnakc4aph2km3u7' }
      end
      it { is_expected.to be_nil }
    end
  end

end

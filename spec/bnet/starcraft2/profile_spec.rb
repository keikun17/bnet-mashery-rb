require "spec_helper"

describe Bnet::Starcraft2::Profile do
  describe ".from_api" do
    let(:attrs){
      {
        "id" => 1,
        "realm" =>  2,
        "displayName" => "Testname",
        "clanName" => "Jade Falcon",
        "clanTag" => "CJF"
      }
    }
    subject{ described_class.from_api(attrs)}

    it "is initialized" do
      expect(subject).to be_a_kind_of(described_class)
      expect(subject.name).to eq("Testname")
    end
  end

  describe ".find" do
    subject { described_class.find(attrs) }
    context "Specified user exists for the server", vcr: {cassette_name: 'sc2_profile_found'} do
      let (:attrs) {
        {region: 'us', profile_id: 2143215, name: 'PlayerOne'}
      }
      it "returns an instance" do
        expect(subject.name).to eq("PlayerOne")
      end

      it "sets the region" do
        expect(subject.region).to eq('us')
      end

      it "sets the achievement point details" do
        expect(subject.achievement_points).to eq(550)
      end

      it "sets the level information"  do
        expect(subject.swarm_level).to eq(2)
        expect(subject.terran_level).to eq(0)
        expect(subject.protoss_level).to eq(2)
        expect(subject.zerg_level).to eq(0)
      end

      it "assigns the career" do
        expect(subject.career).to have_attributes(
          :career_total_games =>  780,
          :highest_1v1_rank   =>  "DIAMOND",
          :highest_team_rank  =>  "MASTER",
          :primary_race       =>  "PROTOSS",
          :season_total_games =>  0,
          :terran_wins        =>  0,
          :zerg_wins          =>  0
        )
      end

    end

    context "specified user does not exist on the server", {vcr: {cassette_name: "sc2_profile_not_found" }} do
      let (:attrs) {
        {region: 'us', profile_id: 2143215, name: 'PlayeZero'}
      }

      it {is_expected.to be_nil}
    end
  end

  describe '#matches' do
    context 'Naniwa user is found', vcr: {cassette_name: 'SC2 Naniwa profile found' } do
      subject { profile.matches }
      let(:profile) {
        Bnet::Starcraft2::Profile.find(profile_id: 2210662, name: 'NaNiwa', region: 'eu')
      }

      it "returns a collection of matches for a given profile"  do
        expect(subject).to_not be_empty
        expect(subject).to include(
          an_object_having_attributes( map: "Deadwing LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410222237),
          an_object_having_attributes( map: "Deadwing LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410221657),
          an_object_having_attributes( map: "King Sejong Station LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410220846)
        )
      end
    end
  end

  describe '#current_ladder_season' do
    context "Jabito's ladder records user are found", vcr: {cassette_name: "SC2 Jabito's Ladder Records" } do
      subject { profile.current_ladder_season }
      let(:profile) do
        Bnet::Starcraft2::Profile.find(profile_id: 2144359, name: 'JaBiTo', region: 'us')
      end
      it "returns the current ladders statistics for the profile" do
        expect(subject).to_not be_empty
        expect(subject).to include( an_object_having_attributes(ladder_name: 'Arbiter Epsilon'))
        expect(subject[0].characters[0]['displayName']).to eq('JaBiTo')
      end
    end
  end

  describe "#previous_ladder_season" do
    subject { profile.previous_ladder_season }
    context "Jabito's ladder records user are found", vcr: {cassette_name: "SC2 Jabito's Ladder Records" } do
      let(:profile) do
        Bnet::Starcraft2::Profile.find(profile_id: 2144359, name: 'JaBiTo', region: 'us')
      end

      it "returns the previous ladder statisttics for the profile" do
        expect(subject).to_not be_empty
        expect(subject).to include( an_object_having_attributes(ladder_name: 'Arbiter Epsilon'))
        expect(subject[0].characters[0]['displayName']).to eq('JaBiTo')
      end
    end
  end
end

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
      expect(subject.display_name).to eq("Testname")
    end
  end

  describe ".find" do
    subject { described_class.find(attrs) }
    context "Specified user exists for the server", vcr: {cassette_name: 'sc2_profile_found'} do
      let (:attrs) {
        {region: 'us', profile_id: 2143215, name: 'PlayerOne'}
      }
      it "returns an instance" do
        expect(subject.display_name).to eq("PlayerOne")
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
    end

    context "specified user does not exist on the server", {vcr: {cassette_name: "sc2_profile_not_found" }} do
      let (:attrs) {
        {region: 'us', profile_id: 2143215, name: 'PlayeZero'}
      }

      it {is_expected.to be_nil}
    end
  end

end

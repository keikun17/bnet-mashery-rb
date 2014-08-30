require 'spec_helper'

describe Mashery::WOW::Character do

  describe ".from_api" do
    let(:attrs) {
      {
        "name" => 'Alexeistukov',
        "realm" => 'Dalvengyr',
        "battlegroup" => 'somebg',
        "class" => 3,
        "race" => 9,
        "gender" => 1,
        "level" => 85,
        "achievement_points" => 1000,
        "calc_class" => "b'",
        "total_honorable_kills" => 100
      }
    }
    subject{ described_class.from_api(attrs)}

    it "initializes and instance when passed with mashery json args" do
      expect(subject).to be_a_kind_of(described_class)
      expect(subject.name).to eq("Alexeistukov")
      expect(subject.level).to eq(85)
      expect(subject.realm).to eq('Dalvengyr')
      #TODO assigns :gender, :class, :race
    end
  end

  describe ".find" do
    subject { described_class.find(attrs) }
    context "Specified character exists for the server", vcr: {cassette_name: 'wow_character_found'} do
      let(:attrs){
        {
          region: 'us', name: 'AlexeiStukov', realm: 'Dragonmaw',
          key: VCR::SECRETS["api_key"]
        }
      }
      it "returns the instance" do
        expect(subject).to be_a_kind_of(described_class)
        expect(subject.name).to eq("Alexeistukov")
      end
    end

    context "specified character does not exist on the server", vcr: {cassette_name: 'wow_character_not_found'} do
      let(:attrs){
        {
          region: 'us', name: 'NotHereYo', realm: 'Dragonmaw',
          key: VCR::SECRETS["api_key"]
        }
      }
      it { is_expected.to be_nil }
    end
  end

end

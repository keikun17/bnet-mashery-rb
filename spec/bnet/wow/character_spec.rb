require 'spec_helper'

describe Bnet::WOW::Character do

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

    it "initializes and instance when passed with bnet json args" do
      expect(subject).to be_a_kind_of(described_class)
      expect(subject.name).to eq("Alexeistukov")
      expect(subject.level).to eq(85)
      expect(subject.realm).to eq('Dalvengyr')
      expect(subject.gender).to eq('Male')
      #TODO assigns :gender, :class, :race
    end
  end

  describe ".find" do
    subject { described_class.find(attrs) }
    context "Specified character exists for the server", vcr: {cassette_name: 'wow_character_found'} do
      let(:attrs){
        {
          region: 'us', name: 'AlexeiStukov', realm: 'Dragonmaw'
        }
      }
      it "returns the instance" do
        expect(subject).to be_a_kind_of(described_class)
        expect(subject.name).to eq("Alexeistukov")
        expect(subject.realm).to eq("Dragonmaw")
        expect(subject.region).to eq("us")
      end
    end

    context "specified character does not exist on the server", vcr: {cassette_name: 'wow_character_not_found'} do
      let(:attrs){
        {
          region: 'us', name: 'NotHereYo', realm: 'Dragonmaw'
        }
      }
      it { is_expected.to be_nil }
    end
  end

  context "Alexeistukov character" do
    subject(:character) { described_class.new(region: 'us', realm: 'Dragonmaw', name: 'Alexeistukov')}

    describe "#achievements", vcr: {cassette_name: 'WoW Alexeistukov achievements'} do
      it { expect(subject.achievements).to_not be_empty }
    end

    describe "#appearance", vcr: {cassette_name: 'WoW Alexeistukov Appearance'} do
      it { expect(subject.appearance).to_not be_empty }
    end

    describe "#feed", vcr: {cassette_name: 'WoW Alexeistukov Feed'} do
      it { expect(subject.feed).to_not be_empty }
    end
  end

end

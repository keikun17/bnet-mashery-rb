require 'spec_helper'

shared_examples_for "memoized WoW character scope" do
  it 'memoizes character scope calls' do
    client = instance_double('Bnet::WOW')
    expect(Bnet::WOW).to receive(:new).and_return(client).exactly(:once)
    expect(client).to receive(:scoped).exactly(:once).and_return([1,2,3])
    subject.send(scope)
    subject.send(scope)
  end
end

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
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'achievements'}
      end
    end

    describe "#appearance", vcr: {cassette_name: 'WoW Alexeistukov Appearance'} do
      it { expect(subject.appearance).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'appearance'}
      end
    end

    describe "#feed", vcr: {cassette_name: 'WoW Alexeistukov Feed'} do
      it { expect(subject.feed).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'feed'}
      end
    end

    describe "#guild", vcr: {cassette_name: 'WoW Alexeistukov Guild'} do
      it { expect(subject.guild).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'guild'}
      end
    end

    describe "#hunter_pets", vcr: {cassette_name: 'WoW Alexeistukov Hunter Pets'} do
      it { expect(subject.hunter_pets).to be_nil }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'hunter_pets'}
      end
    end

    describe "#items", vcr: {cassette_name: 'WoW Alexeistukov Items'} do
      it { expect(subject.items).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'items'}
      end
    end

    describe "#mounts", vcr: {cassette_name: 'WoW Alexeistukov Mounts'} do
      it { expect(subject.mounts).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'mounts'}
      end
    end
  end

end

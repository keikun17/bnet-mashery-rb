require 'spec_helper'

describe Mashery::WOW::Data::CharacterRace do
  describe ".find_all", vcr: {cassette_name: 'wow_data_character_races_all'} do
    let(:args){ {key: VCR::SECRETS["api_key"], region: 'us'} }

    subject(:collection) {described_class.find_all(args)}
    it "returns a collection of CharacterRace instances" do
      expect(collection).to_not be_empty
      collection.each do |character_race|
        expect(character_race).to be_a_kind_of(described_class)
        expect(character_race.race_id).to_not be_nil
        expect(character_race.mask).to_not be_nil
        expect(character_race.name).to_not be_empty
        expect(character_race.side).to_not be_empty
      end
    end
  end
end

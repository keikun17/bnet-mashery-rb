require 'spec_helper'

describe Mashery::WOW::Data::Battlegroup do
  describe ".find_all", vcr: {cassette_name: 'wow_data_battlegroups_all'} do
    let(:args){ {key: VCR::SECRETS["api_key"], region: 'us'} }

    subject(:collection) {described_class.find_all(args)}
    it "returns a collection of Battlegroup instances" do
      expect(collection).to_not be_empty
      collection.each do |battleground|
        expect(battleground).to be_a_kind_of(described_class)
        expect(battleground.name).to_not be_empty
        expect(battleground.slug).to_not be_empty
      end
    end
  end
end

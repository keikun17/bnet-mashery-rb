require 'spec_helper'

describe Mashery::WOW::Character do

  describe ".from_api" do
    it "is initialized"
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

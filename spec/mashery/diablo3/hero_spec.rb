require 'spec_helper'

describe Mashery::Diablo3::Hero do

  describe ".find" do
    subject {described_class.find(args)}

    context "Given the correct battletag and hero id", vcr: {cassette_name: 'diablo_hero_found'} do
      let(:args) do
        {
          battletag: 'PlayerOne-1309',
          region: 'us',
          key: VCR::SECRETS["api_key"],
          hero_id: 1304986
        }
      end

      it "Instantiates a hero " do
        is_expected.to be_a_kind_of(described_class)
        expect(subject.name).to eq('PlayerOne')
        expect(subject.hero_class).to eq('wizard')
      end

    end

    context "Given the hero does not exist on that tag/realm", vcr: {cassette_name: 'diablo_hero_notf_found'} do
      let(:args) do
        {
          battletag: 'DOESNTEXIST-666',
          region: 'us',
          key: VCR::SECRETS["api_key"],
          hero_id: 666
        }
      end

      it { is_expected.to be_nil }
    end

  end

  describe ".from_api" do

    context "Given the right parameters" do
      let(:api_args) do
        { "paragonLevel" => 0, "seasonal" => false, "name" => "PlayerOne",
          "id" => 1304986, "level" => 70, "hardcore" => false, "gender" => 0,
          "dead" => false, "class" => "wizard", "last-updated" => 1397322512
        }
      end
      subject { described_class.from_api(api_args) }

      it "can be initialized" do
        is_expected.to_not be_nil
      end

    end
  end

end

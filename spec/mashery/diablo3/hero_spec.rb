require 'spec_helper'

describe Mashery::Diablo3::Hero do

  describe ".find" do
    subject {described_class.find(args)}

    context "Given the correct battle tag and hero id", vcr: {cassette_name: 'diablo_hero_found'} do
      let(:args) do
        {
          battle_tag: 'PlayerOne-1309',
          region: 'us',
          hero_id: 1304986
        }
      end

      it "Instantiates a hero " do
        is_expected.to be_a_kind_of(described_class)
        expect(subject.name).to eq('PlayerOne')
        expect(subject.hero_class).to eq('wizard')
      end

      it "assigns skills" do
        expect(subject.active_skills.map(&:name)).
          to match_array([ "Magic Missile", "Arcane Orb",
                           "Hydra", "Familiar", "Magic Weapon",
                           "Teleport" ])

        expect(subject.active_skills.map(&:rune)).
          to match_array([ "Seeker", "Frozen Orb", "Frost Hydra", "Sparkflint",
                           "Force Weapon", "Fracture"])

        expect(subject.passive_skills.map(&:name)).
          to match_array([ "Elemental Exposure", "Prodigy", "Astral Presence",
                           "Cold Blooded" ])
      end

    end

    context "Given the hero does not exist on that tag/realm", vcr: {cassette_name: 'diablo_hero_notf_found'} do
      let(:args) do
        {
          battle_tag: 'DOESNTEXIST-666',
          region: 'us',
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


  describe "#reload" do
    context "Hero since last update was level 69", vcr: {cassette_name: 'diablo_hero_reload'} do
      let(:hero) do
        described_class.new(battle_tag: 'PlayerOne#1309',region: 'us', hero_id: 1304986, level: 69)
      end
      it "Fetches  update from the API and update the object"
      # expect{hero.reload}.to change{hero.level}.from(69).to(70)
  end
  end
end

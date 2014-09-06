require 'spec_helper'

describe Bnet::Diablo3::Hero do

  describe ".find(battle_tag: 'PlayerOne-1309', region: 'us', hero_id: 1304986)" do
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

      it "assigns items"

      it "assigns stats" do
        expect(subject).to have_attributes({
          life:                 266712,
          damage:               412878.0,
          attack_speed:         1.284000051021576,
          armor:                5327,
          strength:             77,
          dexterity:            77,
          vitality:             3089,
          intelligence:         7189,
          physical_resist:      1021,
          fire_resist:          1152,
          cold_resist:          897,
          lightning_resist:     1190,
          poison_resist:        897,
          arcane_resist:        1040,
          crit_damage:          3.18,
          block_chance:         0.0,
          block_amount_min:     0,
          block_amount_max:     0,
          damage_increase:      0.0,
          crit_chance:          0.38500000075,
          damage_reduction:     0.0,
          thorns:               0.0,
          life_steal:           0.0,
          life_per_kill:        6701.0,
          gold_find:            2.03,
          magic_find:           0.0,
          life_on_Hit:          6542.0,
          primary_resource:     133,
          secondary_resource:   0
        })
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
      it "Fetches  update from the API and update the object" do
        expect{hero.reload}.to change{hero.level}.from(69).to(70)
      end
    end
  end

  describe '#career' do
    it "returns a career object"
  end

end

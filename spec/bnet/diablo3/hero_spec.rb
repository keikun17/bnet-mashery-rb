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

      it "assigns follower" do
        expect(subject.followers).to match([
          an_object_having_attributes(
            follower_type: 'templar', level: 70,
            gold_find: 11, magic_find: 0, experience_bonus: 19,
            skills: include(
              an_object_having_attributes(name: "Intervene"),
              an_object_having_attributes(name: "Loyalty"),
              an_object_having_attributes(name: "Charge"),
              an_object_having_attributes(name: "Inspire")
            ),
            items: include(
              an_object_having_attributes(name: "Intrepid Trinket", item_id: 'Templar_Special_203', location: 'special'),
              an_object_having_attributes(name: "Cut Blast", item_id: 'Axe_1H_301', location: 'mainHand'),
              an_object_having_attributes(name: "Savior's Interceptor", item_id: 'Shield_208', location: 'offHand')
            )
          ),

          an_object_having_attributes(
            follower_type: 'scoundrel', level: 70,
            gold_find: 0, magic_find: 0, experience_bonus: 0,
            skills: match([]),
            items: include(
              an_object_having_attributes(name: "Unwavering Find", item_id: 'Scoundrel_Special_204', location: 'special'),
              an_object_having_attributes(name: "Light Crossbow of Slaying", item_id: 'Crossbow_001', location: 'mainHand'),
              an_object_having_attributes(name: "Loyalty Aim", item_id: 'Ring_18', location: 'rightFinger')
            )
         ),

          an_object_having_attributes(
            follower_type: 'enchantress', level: 70,
            gold_find: 0, magic_find: 0, experience_bonus: 0,
            items: include(
              an_object_having_attributes(name: "Citadel Bounty", item_id: 'Enchantress_Special_204', location: 'special'),
              an_object_having_attributes(name: "Adept's Atrocity", item_id: 'Staff_203', location: 'mainHand'),
              an_object_having_attributes(name: "Black Wheel", item_id: 'Ring_19', location: 'rightFinger')
            )
          )
        ])
      end

      it "assigns items" do
        expect(subject.items).to match([
          an_object_having_attributes(location: "head", name: "Leoric's Crown", item_id: "Unique_Helm_002_x1" ),
          an_object_having_attributes(location: "torso"),
          an_object_having_attributes(location: "feet"),
          an_object_having_attributes(location: "hands"),
          an_object_having_attributes(location: "shoulders"),
          an_object_having_attributes(location: "legs"),
          an_object_having_attributes(location: "bracers"),
          an_object_having_attributes(location: "mainHand"),
          an_object_having_attributes(location: "offHand"),
          an_object_having_attributes(location: "waist"),
          an_object_having_attributes(location: "rightFinger"),
          an_object_having_attributes(location: "leftFinger"),
          an_object_having_attributes(location: "neck")
        ])
      end

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

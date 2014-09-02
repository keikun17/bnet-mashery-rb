require 'spec_helper'

describe Mashery::Diablo3::Career do

  describe ".from_api" do
    let(:attrs){
      { 
        "heroes" => [], "lastheroplayed" => 'val', "lastupdated" => 'val',
        "kills" => 'val', "timeplayed" => 'val', "fallenheroes" => 'val',
        "paragonlevel" => 'val', "paragonlevelhardcore" => 'val',
        "battletag" => 'val', "progression" => 'val'
      }
    }
    subject{ described_class.from_api(attrs)}
    it "is initialized" do
      expect(subject).to be_a_kind_of(described_class)
    end
  end

  describe ".find" do
    subject(:career) { described_class.find(args) }

    context "Playertag for the server exists" ,vcr: { cassette_name: 'find_diablo_career_player_one '} do
      let(:args) do
        { battle_tag: 'PlayerOne#1309', region: 'us' }
      end
      it { is_expected.to_not be_nil }

      it "sets account attributes that are of the json response" do
        expect(career.battle_tag).to eq('PlayerOne#1309')
        expect(career.region).to eq('us')
      end

      it "assigns the heroes attribute" do
        expect(career.heroes).to_not be_empty

        career.heroes.each do |hero|
          expect(hero).to be_a_kind_of(Mashery::Diablo3::Hero)
          expect(hero.battle_tag).to eq('PlayerOne#1309')
          expect(hero.region).to eq(career.region)
          expect(hero.career).to be(career)
        end

      end
    end

    context "Playertag for the server does not exist", vcr: { cassette_name: 'find_diablo_career_doesnt_exist'} do
      let(:args) do
        { battle_tag: 'DoesntExist-42', region: 'us' }
      end
      it { is_expected.to be_nil }
    end
  end

end

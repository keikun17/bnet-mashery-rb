require 'spec_helper'

describe Bnet::Starcraft2::Ladder do

  describe '.find_current(profile)', vcr: {cassette_name: 'SC2 Jabito Ladder records'} do
    subject {described_class.find_current(profile)}
    let(:profile) { Bnet::Starcraft2::Profile.new(profile_id: 2144359, name: 'JaBiTo', region: 'us') }

    it "should return a collection of ladder objects" do
      expect(subject).to include(
        an_object_having_attributes(ladder_name: 'Arbiter Epsilon',
                                    ladder_id: 175161,
                                    division: 72,
                                    rank: 47,
                                    league: 'DIAMOND',
                                    matchmaking_queue: 'HOTS_SOLO',
                                    wins: 21,
                                    losses: 7
                                   )
      )
    end

    it "assigns characters to ladder instances" do
      subject[0].characters.each do |character|
        expect(character).to_not be_empty
        expect(character['id']).to eq(2144359)
        expect(character['realm']).to eq(1)
        expect(character['displayName']).to eq('JaBiTo')
        expect(character['clanTag']).to be_empty
        expect(character['clanName']).to be_empty
      end
    end

  end

  describe '.find_previous(profile)', vcr: {cassette_name: 'SC2 Jabito Ladder records'} do
    subject {described_class.find_previous(profile)}
    let(:profile) { Bnet::Starcraft2::Profile.new(profile_id: 2144359, name: 'JaBiTo', region: 'us') }

    it "should return Jabito's previous ladder records" do
      expect(subject).to have_at_least(7).items

      expect(subject).to include(
        an_object_having_attributes(ladder_name: 'Thor Oscar',
                                    ladder_id: 171549,
                                    division: 9,
                                    rank: 31,
                                    league: 'SILVER',
                                    matchmaking_queue: 'HOTS_FOURS',
                                    wins: 5,
                                    losses: 2
                                   ))
    end

    context "the hots 4v4 record" do
      let( :coop_4v4_ladder) { subject[0]  }
      it "assigns characters to ladder instances" do
        expect(coop_4v4_ladder).to have_exactly(4).characters

        player_one = coop_4v4_ladder.characters[0]
        expect(player_one).to_not be_empty
        expect(player_one['id']).to eq(2068331)
        expect(player_one['realm']).to eq(1)
        expect(player_one['displayName']).to eq('SaiirupPC')
        expect(player_one['clanTag']).to eq('pinoy')
        expect(player_one['clanName']).to eq('xXxClan')

        player_two = coop_4v4_ladder.characters[1]
        expect(player_two).to_not be_empty
        expect(player_two['id']).to eq(2144359)
        expect(player_two['realm']).to eq(1)
        expect(player_two['displayName']).to eq('JaBiTo')
        expect(player_two['clanTag']).to be_empty
        expect(player_two['clanName']).to be_empty

      end
    end

  end
end

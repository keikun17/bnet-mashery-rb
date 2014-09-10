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

end

# => {"primaryRace"=>"PROTOSS", "terranWins"=>0, "protossWins"=>0, "zergWins"=>0, "highest1v1Rank"=>"DIAMOND",

require 'spec_helper'

describe Bnet::Starcraft2::Career  do
  describe '.from_api(args)' do
    subject { described_class.from_api(args) }
    let(:args) do
      {
        'primaryRace'     => 'PROTOSS',
        'terranWins'      => 1,
        'protosswins'     => 3,
        'zergWins'        => 0,
        'highest1v1Rank'  => "DIAMOND",
        'highestTeamRank' => "MASTER",
        "seasonTotalGames" => 0,
        "careerTotalGames" => 780
      }
    end


    it "returns an instance" do
      expect(subject).to be_a_kind_of(described_class)
      expect(subject).to have_attributes(
        primary_race: 'PROTOSS',
        terran_wins: 1,
        protoss_wins: 3,
        zerg_wins: 0,
        highest_1v1_rank: 'DIAMOND',
        highest_team_rank: 'MASTER',
        season_total_games: 0,
        career_total_games: 780
      )
    end
  end

end




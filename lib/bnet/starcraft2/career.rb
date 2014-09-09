class Bnet::Starcraft2::Career < Bnet::BnetResource
  attr_accessor :primary_race, :terran_wins, :protoss_wins, :zerg_wins,
    :highest_1v1_rank, :highest_team_rank, :season_total_games,
    :career_total_games

  PARAMS_MAPPING = {
    'primaryRace'       => :primary_race,
    'terranWins'        => :terran_wins,
    'protosswins'       => :protoss_wins,
    'zergWins'          => :zerg_wins,
    'highest1v1Rank'    => :highest_1v1_rank,
    'highestTeamRank'   => :highest_team_rank,
    "seasonTotalGames"  => :season_total_games,
    "careerTotalGames"  => :career_total_games
  }

  def self.from_api(raw_response)
    career = super(raw_response)
    return career
  end
end

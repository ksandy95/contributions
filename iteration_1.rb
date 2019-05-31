require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative 'game_module'
require_relative 'league_module'
require_relative 'season_module'
require_relative 'team_module'

class StatTracker
  include GameModule
  include TeamModule
  include LeagueModule
  include SeasonModule

  attr_reader :games, :teams, :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    games = []
    teams = []
    game_teams = []

    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |row|
      games << Game.new(row)
    end
    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      teams << Team.new(row)
    end
    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_teams << GameTeam.new(row)
    end
    self.new(games, teams, game_teams)
  end
end


==============================================================================

require_relative 'test_helper'
require 'csv'
require 'pry'
require './lib/game'
require './lib/stat_tracker'
require './lib/game_module'

class StatTrackerTest < Minitest::Test

    def setup
      locations = {
        games: './test/data/game.csv',
        teams: './test/data/team_info.csv',
        game_teams: './test/data/game_teams_stats.csv'
      }
      @stat_tracker = StatTracker.from_csv(locations)
    end

    def test_it_exists

      assert_instance_of StatTracker, @stat_tracker
    end


    def test_game_attributes

      assert_equal @stat_tracker.games.first.away_team_id, "6"
      assert_equal @stat_tracker.games.first.home_team_id, "5"
      assert_equal @stat_tracker.games.first.outcome, "away win REG"
      assert_equal @stat_tracker.games.first.game_id, "2012030311"
      assert_equal @stat_tracker.games.first.outcome, "away win REG"
      assert_equal @stat_tracker.games.first.season, "20122013"
      assert_equal @stat_tracker.games.first.type, "P"
      assert_equal @stat_tracker.games.first.date_time, "2013-06-02"
      assert_equal @stat_tracker.games.first.away_goals, 3
      assert_equal @stat_tracker.games.first.home_goals, 0
      assert_equal @stat_tracker.games.first.home_rink_side_start, "left"
      assert_equal @stat_tracker.games.first.venue, "CONSOL Energy Center"
      assert_equal @stat_tracker.games.first.venue_link, "/api/v1/venues/null"
      assert_equal @stat_tracker.games.first.venue_time_zone_id, "America/New_York"
      assert_equal @stat_tracker.games.first.venue_time_zone_offset, "-4"
      assert_equal @stat_tracker.games.first.venue_time_zone_tz, "EDT"
    end

    def test_team_attributes

      assert_equal @stat_tracker.teams.first.team_id, "1"
      assert_equal @stat_tracker.teams.first.franchise_id, "23"
      assert_equal @stat_tracker.teams.first.short_name, "New Jersey"
      assert_equal @stat_tracker.teams.first.team_name, "Devils"
      assert_equal @stat_tracker.teams.first.abbreviation, "NJD"
      assert_equal @stat_tracker.teams.first.link, "/api/v1/teams/1"
    end

    def test_game_team_attributes

      assert_equal @stat_tracker.game_teams.first.game_id, "2012030221"
      assert_equal @stat_tracker.game_teams.first.team_id, "3"
      assert_equal @stat_tracker.game_teams.first.hoa, "away"
      assert_equal @stat_tracker.game_teams.first.won, "FALSE"
      assert_equal @stat_tracker.game_teams.first.settled_in, "OT"
      assert_equal @stat_tracker.game_teams.first.head_coach, "John Tortorella"
      assert_equal @stat_tracker.game_teams.first.goals, 2
      assert_equal @stat_tracker.game_teams.first.shots, 35
      assert_equal @stat_tracker.game_teams.first.hits, 44
      assert_equal @stat_tracker.game_teams.first.pim, 8
      assert_equal @stat_tracker.game_teams.first.pp_opportunities, 3
      assert_equal @stat_tracker.game_teams.first.pp_goals, 0
      assert_equal @stat_tracker.game_teams.first.face_off_win_percentage, 44.8
      assert_equal @stat_tracker.game_teams.first.giveaways, 17
      assert_equal @stat_tracker.game_teams.first.takeaways, 7
    end
end

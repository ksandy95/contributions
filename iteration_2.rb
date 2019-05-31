require_relative 'test_helper'
require 'pry'
require './lib/game'
require './lib/stat_tracker'
require './lib/game_module'

class GameTest < Minitest::Test

    def setup
      locations = {
        games: './test/data/game.csv',
        teams: './test/data/team_info.csv',
        game_teams: './test/data/game_teams_stats.csv'
      }
      @stat_tracker = StatTracker.from_csv(locations)
    end

    def test_highest_total_score

      assert_equal 12, @stat_tracker.highest_total_score
    end

    def test_lowest_total_score

      assert_equal 1, @stat_tracker.lowest_total_score
    end

    def test_biggest_blowout

      assert_equal 5, @stat_tracker.biggest_blowout
    end

    def test_percentage_home_wins

      assert_equal 0.54, @stat_tracker.percentage_home_wins
    end

    def test_percentage_visitor_wins

      assert_equal 0.46, @stat_tracker.percentage_visitor_wins
    end

    def test_count_of_games_by_season
      expected = {"20122013"=>44,
        "20152016"=>17,
        "20162017"=>17,
        "20172018"=>17
      }

      assert_equal expected, @stat_tracker.count_of_games_by_season
    end

    def test_average_goals_per_game

      assert_equal 5.74, @stat_tracker.average_goals_per_game
    end

    def test_average_goals_by_season
      expected = {
         "20122013"=>5.0,
         "20152016"=>6.24,
         "20162017"=>6.53,
         "20172018"=>6.35
       }

      assert_equal expected, @stat_tracker.average_goals_by_season
    end
end





====================================================================



require 'csv'
require 'pry'

class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :outcome,
              :home_rink_side_start,
              :venue,
              :venue_link,
              :venue_time_zone_id,
              :venue_time_zone_offset,
              :venue_time_zone_tz

  def initialize(row)
    @game_id = row[:game_id]
    @season = row[:season]
    @type = row[:type]
    @date_time = row[:date_time]
    @away_team_id = row[:away_team_id]
    @home_team_id = row[:home_team_id]
    @away_goals = row[:away_goals].to_i
    @home_goals = row[:home_goals].to_i
    @outcome = row[:outcome]
    @home_rink_side_start = row[:home_rink_side_start]
    @venue = row[:venue]
    @venue_link = row[:venue_link]
    @venue_time_zone_id = row[:venue_time_zone_id]
    @venue_time_zone_offset = row[:venue_time_zone_offset]
    @venue_time_zone_tz = row[:venue_time_zone_tz]
  end

end


require 'pry'

module GameModule

  def get_total_score
    games.map do |game|
      game.home_goals + game.away_goals
    end
  end

  def highest_total_score
    get_total_score.max
  end

  def lowest_total_score
    get_total_score.min
  end

  def biggest_blowout
    games.map do |game|
      (game.home_goals - game.away_goals).abs
    end.max
  end

  def win_counter(hoa)
    games.find_all do |game|
      game.outcome.include? hoa
    end.count
  end

  def percentage_home_wins
    (win_counter("home") / games.count.to_f).round(2)
  end

  def percentage_visitor_wins
    (win_counter("away") / games.count.to_f).round(2)
  end

  def count_of_games_by_season
    games_by_seasons = games.group_by{ |game| game.season.to_s }
    games_by_seasons.transform_values{ |values| values.count }
  end

  def average_goals_per_game
    (get_total_score.sum / games.count.to_f).round(2)
  end

  def average_goals_by_season
    games_by_seasons = games.group_by{ |game| game.season.to_s }
    games_by_seasons.transform_values do |row|
      total_goals = row.sum{ |column| column.home_goals + column.away_goals }
      (total_goals / row.count.to_f).round(2)
    end
  end

end

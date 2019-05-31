require 'pry'
require 'csv'

class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :won,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :hits,
              :pim,
              :pp_opportunities,
              :pp_goals,
              :face_off_win_percentage,
              :giveaways,
              :takeaways
  def initialize(row)
    @game_id = row[:game_id]
    @team_id = row[:team_id]
    @hoa = row[:hoa]
    @won = row[:won]
    @settled_in = row[:settled_in]
    @head_coach = row[:head_coach]
    @goals = row[:goals].to_i
    @shots = row[:shots].to_i
    @hits = row[:hits].to_i
    @pim = row[:pim].to_i
    @pp_opportunities = row[:powerplayopportunities].to_i
    @pp_goals =row[:powerplaygoals].to_i
    @face_off_win_percentage = row[:faceoffwinpercentage].to_f
    @giveaways = row[:giveaways].to_i
    @takeaways = row[:takeaways].to_i
  end
end

============================================================
def get_teams
    team_ids = []
    games.each do |game|
      team_ids << game.away_team_id
      team_ids << game.home_team_id
    end
    team_ids.uniq
  end


def win_percentage_by_team
    win_per_by_team = {}
    @teams.each do |teams|
      relevant_games = []
      @game_teams.each do |games|
        if teams.team_id == games.team_id
          relevant_games << games
        end
      end
      wins = []
      relevant_games.each do |stat|
        if stat.won == "TRUE"
          wins << stat
        end
      end
        final = (wins.count/relevant_games.count.to_f).round(2)
        final = 0.000001 if final.nan?
        win_per_by_team[teams.team_name] = final
    end
    win_per_by_team
  end

  def winningest_team
    a = win_percentage_by_team.max_by{|team, percentage| percentage}
    a.first
  end

  def fans
    gamess = @game_teams.group_by{|teams| teams.team_id}
    gamess.transform_values do |games|
    home_wins = 0
    away_wins = 0
    games_played_home = 0
    games_played_away = 0
    games.each do |game|
        home_wins += 1 if game.won == "TRUE" && game.hoa == "home"
        away_wins += 1 if game.won == "TRUE" && game.hoa == "away"
        games_played_home += 1 if game.hoa == "home"
        games_played_away += 1 if game.hoa == "away"
      end
    home_win_percent = (home_wins/games_played_home.to_f).round(2)
    away_win_percent = (away_wins/games_played_away.to_f).round(2)
    fan_per = (home_win_percent - away_win_percent.to_f).round(2)
    end
  end
  
  def worst_fans
    fans.min
  end

  def best_fans
    team_stuff = []
    @game_teams.each do |game|
      @teams.each do |team|
        if game.team_id == team.team_id
          team_stuff << [team.team_name, game.team_id]
        end
      end
    end
    a = team_stuff.uniq.last
    a[0]
  end

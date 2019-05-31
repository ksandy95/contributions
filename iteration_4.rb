
class Team
  attr_reader :team_id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link

  def initialize(row)
    @team_id = row[:team_id]
    @franchise_id = row[:franchiseid]
    @short_name = row[:shortname]
    @team_name = row[:teamname]
    @abbreviation = row[:abbreviation]
    @link = row[:link]
  end
end

============================================
# these are broken and what i ws trying to get to work from last night.
# below these are ones that were passing the rake but completely wrong for spec harness
# with giving back completely wrong results.
# In the slack file youll see where i came from
# The mthods in there are what i had gotten to
# after refactoring. Ill look for my old old stuff that was the beginnig of these as well


#  def team_jazz(team_id)
 #    @teams.find do |team|
 #      team.team_id == team_id
 #    end
 # end

 # def games_shared(team_id)
#    sg = []
#   rivals(team_id).each do |rival|
#      games.each do |game|
#         if game.away_team_id == team_id && game.home_team_id == rival
#           sg << game
#         elsif game.away_team_id == rival && game.home_team_id == team_id
#           sg << game
#         end
#      end
#    end
#    sg
# end

 # def team_stats_for_game(team_id)
  #   @game_teams.find_all{ |game| game.team_id == team_id }
  # end
  #
  # def results_by_rival(team_id)
  #   games = team_stats_for_game(team_id)
  #   against= Hash.new{ |hash,other_dudes| hash[other_dudes] = {win: 0, lose: 0}}
  #   games.each do |gamess|
  #     other_dudes = @game_teams.find do |game|
  #       game.game_id == gamess.game_id &&
  #       game.team_id != gamess.team_id
  #     end.team_id
  #     outcome = gamess.won ? :win : :lose
  #     against[other_dudes][outcome] += 1
  #   end
  #   return against
  # end
  #
  # def favorite_opponent(team_id)
  #   against = results_by_rival(team_id)
  #     fav_rival = against.max_by do |other_dudes, game_stats|
  #        stats[:win] / stats[:lose].to_f
  #     end[0]
  #  get_team(rav_rival).team_name
  # end
  #
  # def rival(team_id)
  #   against = results_by_rival(team_id)
  #     rival_id = against.min_by do |other_dudes, game_stats|
  #       stats[:win] / stats[:lose].to_f
  #     end[0]
  #   get_team(rival_id).team_name
  # end
  #
  # def head_to_head(team_id)
  #   heads = {}
  #   results_by_rival(team_id).each do |other_dudes_id,outcome|
  #     other_name = team_jazz(other_id).team_name
  #     games_played = outcome[:win] + outcome[:loss].to_f
  #     heads[other_name] = (outcome[:win] / games_played).round(2)
  #   end
  #   heads
  # end

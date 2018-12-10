#478 players; last marble is worth 71240 points

num_players = 478
highest_marble = 71240

@players = (0...num_players).map{0}

@circle = [0]

@current_marble_index = 0
@current_marble = 0
@current_player = 0

def turn
  points = 0
  @current_marble +=1
  @current_player = 0 if @current_player >= @players.count
  @current_player += 1

  if @current_marble % 23 == 0
    @current_marble_index = @current_marble_index - 7
    @current_marble_index = @circle.count + @current_marble_index if @current_marble_index < 0

    points = @circle.delete_at @current_marble_index
    points += @current_marble
    @players[@current_player - 1] += points
  else
    @current_marble_index = ((@current_marble_index + 1) % @circle.count) +1
    @circle.insert(@current_marble_index, @current_marble)
  end
end

highest_marble.times do
  print "#{(@current_marble / highest_marble.to_f * 100.0 ).round(2)}%\r"
  $stdout.flush
  turn
end

puts "Part 1: #{@players.max}"


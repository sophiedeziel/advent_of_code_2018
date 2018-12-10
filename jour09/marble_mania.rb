require 'pry'
#478 players; last marble is worth 71240 points

@num_players = 478
highest_marble = 71240

class Marble < Struct.new(:value, :previous, :next)
  def destroy
    self.previous.next = self.next
    self.next.previous = self.previous
  end

  def insert_after(marble)
    marble.next        = self.next
    marble.previous    = self
    self.next.previous = marble
    self.next          = marble
  end
end

@players = (0...@num_players).map{0}
@current_marble = Marble.new(0, nil, nil)
@current_marble.next     = @current_marble
@current_marble.previous = @current_marble
@value = 0

def turn
  @value += 1
  new_marble = Marble.new(@value, nil, nil)

  if new_marble.value % 23 == 0
    7.times { @current_marble = @current_marble.previous }
    points = @current_marble.value + new_marble.value

    @players[@value % @num_players] += points
    @current_marble.destroy

    @current_marble = @current_marble.next
  else
    @current_marble = @current_marble.next
    @current_marble.insert_after(new_marble)

    @current_marble = new_marble
  end
end

highest_marble.times do
  turn
end
puts "Part 1: #{@players.max}"

(highest_marble * 100 - highest_marble).times do
  turn
end
puts "Part 2: #{@players.max}"


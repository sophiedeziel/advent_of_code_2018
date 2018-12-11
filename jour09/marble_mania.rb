class Marble
  attr_accessor :value, :next, :previous
  def initialize(value)
    @value = value
    @next  = self
    @previous = self
  end

  def destroy
    @previous.next = @next
    @next.previous = @previous
  end

  def insert_after(marble)
    marble.next     = @next
    marble.previous = self
    @next.previous  = marble
    @next           = marble
  end
end

num_players = 478
highest_marble = 71240

@players        = Array.new(num_players, 0)
@current_marble = Marble.new(0)
@value = 0

def turn
  @value += 1
  new_marble = Marble.new(@value)

  if new_marble.value % 23 == 0
    7.times { @current_marble = @current_marble.previous }
    points = @current_marble.value + new_marble.value

    @players[@value % @players.count] += points
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


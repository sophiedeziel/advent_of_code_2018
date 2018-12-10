records = File.read('input.txt').split("\n")

class Guard
  attr_accessor :id, :asleep_by_minute, :minutes_asleep

  def initialize(id)
    @id = id
    @minutes_asleep = 0
    @asleep_by_minute = (0..59).map { 0 }
  end

  def register_sleep(fallen, woke_up)
    (fallen...woke_up).each do |i|
      @asleep_by_minute[i] += 1
      @minutes_asleep      += 1
    end
  end

  def most_asleep_minute
    @asleep_by_minute.each_with_index.max[1]
  end
end

current_guard = nil
current_sleep = nil
guards = []

records.sort.each do |line|
  case line
  when /begins shift/
    id = line.match(/#(\d+)/)[1].to_i

    unless current_guard = guards.find { |g| g.id == id }
      current_guard = Guard.new(id)
      guards << current_guard
    end
  when /falls asleep/
    current_sleep = line.match(/:(\d+)/)[1].to_i
  when /wakes up/
    minute = line.match(/:(\d+)/)[1].to_i
    current_guard.register_sleep(current_sleep, minute)
  end
end

biggest_sleeper = guards.max_by { |guard| guard.minutes_asleep }

most_consistent_sleeper = guards.max_by { |guard| guard.asleep_by_minute[guard.most_asleep_minute] }

puts "Part 1: #{ biggest_sleeper.id * biggest_sleeper.most_asleep_minute }"
puts "Part 2: #{ most_consistent_sleeper.id * most_consistent_sleeper.most_asleep_minute }"



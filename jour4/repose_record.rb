class Guard
  attr_accessor :id, :minutes_asleep, :asleep_by_minutes
  def initialize(id)
    @id = id
    @minutes_asleep = 0
    @asleep_by_minutes = (0...59).map { 0 }
  end

  def register_sleep(fallen, woke_up)
    (fallen...woke_up).each do |i|
      @asleep_by_minutes[i] +=1
      @minutes_asleep += 1
    end
  end

  def most_asleep_minute
    @asleep_by_minutes.each_with_index.max[1]
  end
end

records = File.read('input.txt').split("\n")
guards = []
current_guard = nil
current_sleep = nil

records.sort.each do |line|
  case line
  when /begins shift/
    id = line.match(/#(?<id>\d+)/)[:id].to_i

    unless current_guard = guards.find { |g| g.id == id }
      current_guard = Guard.new(id)
      guards << current_guard
    end

    current_sleep = nil
  when /falls asleep/
    current_sleep = line.match(/\[.+:(?<minute>\d+)\]/)[:minute].to_i
  when /wakes up/
    wakes_up = line.match(/\[.+:(?<minute>\d+)\]/)[:minute].to_i
    current_guard.register_sleep(current_sleep, wakes_up)
  end
end

biggest_sleeper = guards.max_by { |guard| guard.minutes_asleep }
puts "Part 1: #{biggest_sleeper.id * biggest_sleeper.most_asleep_minute }"

most_consistent_sleeper = guards.max_by { |guard| guard.asleep_by_minutes[guard.most_asleep_minute] }
puts "Part 2: #{most_consistent_sleeper.id * most_consistent_sleeper.most_asleep_minute}"



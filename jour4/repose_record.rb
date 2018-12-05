require 'pry'
require 'awesome_print'

records = File.open('input.txt', 'r').map(&:to_s)
schedule = {}
current_guard = nil
current_sleep = nil

@hours_asleep = -> (array) { array.flatten.select { |v| v }.count }

records.sort.each do |line|
  if shift  = line.match(/Guard #(?<id>\d+) begins shift/)
    current_guard = shift[:id]
    current_sleep = nil
  end

  if fall_asleep = line.match(/\[.+:(?<minute>\d+)\] falls asleep/)
    current_sleep = fall_asleep[:minute].to_i
  end

  if wakes_up = line.match(/\[.+:(?<minute>\d+)\] wakes up/)
    current_wake = wakes_up[:minute].to_i
    schedule[current_guard] ||= []
    schedule[current_guard] << (0...59).map {|i| (current_sleep...current_wake).include?(i)}
  end
end

biggest_sleeper = schedule.map do |guard, hours|
  [guard, @hours_asleep.call(hours)]
end.sort_by {|k, v| v}.last

def most_asleep_minute(guards_schedule)
  guards_schedule.transpose.each_with_index.map do |array, index|
    [index, @hours_asleep.call(array)]
  end.sort_by {|k, v| v}.last
end

most_consistent_sleeper =
schedule.map do |guard, hours|
  [guard, most_asleep_minute(hours)]
end.sort_by {|k, v| v[1]}.last


ap "Part 1: #{ biggest_sleeper[0].to_i * most_asleep_minute(schedule[biggest_sleeper[0]])[0] }"
ap "Part 2: #{most_consistent_sleeper[0].to_i * most_consistent_sleeper[1][0]}"


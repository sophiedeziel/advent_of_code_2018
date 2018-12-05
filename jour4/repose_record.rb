require 'pry'
require 'awesome_print'
require_relative 'schedule_parser.rb'

schedule = ScheduleParser.new('input.txt').parse

@hours_asleep       = -> (array)            { array.flatten.select { |v| v }.count }
@map_sleep          = -> (schedule, method) { schedule.map { |key, array| [key, method.call(array)] } }

@most_asleep_minute = -> (guards_schedule) do
  list = guards_schedule.transpose.each_with_index.map{|k,v| [v,k]}
  @map_sleep.call(list, @hours_asleep).sort_by {|k, v| v}.last
end

biggest_sleeper         = @map_sleep.call(schedule, @hours_asleep).sort_by {|k, v| v}.last
most_consistent_sleeper = @map_sleep.call(schedule, @most_asleep_minute).sort_by {|k, v| v[1]}.last

ap "Part 1: #{ biggest_sleeper[0].to_i * @most_asleep_minute.call(schedule[biggest_sleeper[0]])[0] }"
ap "Part 2: #{most_consistent_sleeper[0].to_i * most_consistent_sleeper[1][0]}"


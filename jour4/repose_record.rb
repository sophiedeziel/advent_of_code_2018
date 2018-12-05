require_relative 'schedule_parser.rb'

@biggest_sleeper         = -> { @highest.(@map_sleep.(schedule, @hours_asleep)) }
@most_consistent_sleeper = -> { @highest.(@map_sleep.(schedule, @most_asleep_minute).map{ |k,v| [k, v.reverse] }) }

@hours_asleep       = -> (array)            { array.flatten.select { |v| v }.count }
@map_sleep          = -> (schedule, method) { schedule.map { |key, array| [key, method.call(array)] } }
@highest            = -> (array)            { array.sort_by {|k, v| v}.last }

@most_asleep_minute = -> (guards_schedule) do
  list = guards_schedule.transpose.each_with_index.map{|k,v| [v,k]}
  @highest.(@map_sleep.call(list, @hours_asleep))
end

def strategy_1
  biggest_sleeper = @biggest_sleeper.()
  [biggest_sleeper[0], @most_asleep_minute.(schedule[biggest_sleeper[0]])[0]]
end

def strategy_2
  most_consistent_sleeper = @most_consistent_sleeper.()
  [most_consistent_sleeper[0], most_consistent_sleeper[1][1]]
end

def schedule
  @schedule ||= ScheduleParser.new('input.txt').parse
end

print "Part 1: #{ strategy_1.reduce(:*) }"
print "Part 2: #{ strategy_2.reduce(:*) }"

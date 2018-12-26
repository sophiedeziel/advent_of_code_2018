require 'pry'
require 'colorize'

Sand = '.'
Water = '&'
Clay = '#'

def to_console(input)
  slice = input.map(&:dup)
  min_x = slice.index { |column| !column.all? /[.+]/ }
  slice.shift(min_x - 1)
  slice.transpose.each do |line|
    puts line.join
  end
  puts
end

slice = Array.new

File.open('input.txt').each do |line|
  _line, axis, coordinate, *range = line.match(/([xy])=(\d+), [xy]=(\d+)..(\d+)/).to_a
  coordinate = coordinate.to_i
  range = Range.new(*range.map(&:to_i))

  case axis
  when 'x'
    range.to_a.each do |y|
      slice[coordinate] ||= []
      slice[coordinate][y] = Clay
    end
  when 'y'
    range.to_a.each do |x|
      slice[x] ||= []
      slice[x][coordinate] = Clay
    end
  end
end

max_x = slice.count + 1
max_y = slice.max_by { |line| line&.count || 0 }.count

complete_slice = Array.new(max_x) do
  Array.new max_y, Sand
end




slice.each_with_index do |column, x|
  column&.each_with_index do |value, y|
    complete_slice[x][y] = value if value
  end
end

min_y = complete_slice.transpose.index { |row| !row.all? /[.]/ }

complete_slice.each do |column|
  column.shift(min_y - 1)
end

complete_slice[500][0] = "+"
streams = [[500, 0]]

frames = 0
while streams.any? do
  frames += 1
  x, y = streams.shift

  if complete_slice[x][y + 1] == Sand
    complete_slice[x][y + 1] = '|'
    streams.push [x, y + 1]
  elsif complete_slice[x][y + 1] == Water || complete_slice[x][y + 1] == Clay
    if complete_slice[x + 1][y] == Sand
      complete_slice[x + 1][y] = '|'
      streams.push [x + 1, y]
    end

    if complete_slice[x - 1][y] == Sand
      complete_slice[x - 1][y] = '|'
      streams.push [x - 1, y]
    end

    settling = complete_slice.map{|x| x[y]}.join('').index(/#{Clay}[|]+#{Clay}/)

      if settling
        while complete_slice[settling + 1][y] == '|' do
          complete_slice[settling + 1][y] = Water
          settling += 1
          streams.push [settling, y - 1] if complete_slice[settling][y - 1] == '|'
        end
      end
  end
end

water_touched = complete_slice.sum do |x|
  x.count(Water) + x.count('|')
end

to_console(complete_slice)
puts "Part 1: #{water_touched}"

water_touched = complete_slice.sum do |x|
  x.count(Water)
end
puts "Part 2: #{water_touched}"



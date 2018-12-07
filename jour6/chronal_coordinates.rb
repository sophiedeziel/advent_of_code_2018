require 'pry'
require 'awesome_print'
points = File.open('input.txt').each_with_index.map {|point, index| point.split(', ').map(&:to_i).unshift(index) }

top    = points.min_by { |id, x, y| y }[2] - 1
bottom = points.max_by { |id, x, y| y }[2] + 1
left   = points.min_by { |id, x, y| x }[1] - 1
right  = points.max_by { |id, x, y| x }[1] + 1

map = {}

(left..right).flat_map { |x| (top..bottom).each { |y| map[[x,y]] = nil } }

def calculate_manhattan_distance(ax, ay, bx, by)
  (ax - bx).abs + (ay - by).abs
end

safe_region = 0
map.each do |coordinate, distances|
  map[coordinate] ||= {}
  points.each do |id, x, y|
    map[coordinate][id] = calculate_manhattan_distance(x,y,coordinate[0], coordinate[1])
  end

  sum = map[coordinate].values.reduce(:+)
  safe_region +=1 if sum < 10_000

  sorted = map[coordinate].sort_by { |id, value|  value }
  if sorted[0][1] == sorted[1][1]
    map[coordinate][:min] = nil
  else
    map[coordinate][:min] = sorted.first[0]
  end
end

finite = map.group_by { |coordinate, distances| distances[:min] }.reject do |area, points|
  points.any? do |coordinates, distances|
    [left, right].include?(coordinates[0]) || [top, bottom].include?(coordinates[1])
  end
end

highest = finite.sort_by { |id, points| points.count }.last
puts "Part 1: #{ highest[1].count }"
puts "Part 2: #{ safe_region }"


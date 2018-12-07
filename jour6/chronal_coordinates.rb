Point = Struct.new(:x, :y)
points = File.open('input.txt').each_with_index.map do |point, index|
  [index, Point.new(*point.split(', ').map(&:to_i)) ]
end

top    = points.min_by { |id, point| point.y }[1].y - 1
bottom = points.max_by { |id, point| point.y }[1].y + 1
left   = points.min_by { |id, point| point.x }[1].x - 1
right  = points.max_by { |id, point| point.x }[1].x + 1

map = {}

(left..right).flat_map { |x| (top..bottom).each { |y| map[Point.new(x,y)] = nil } }

def calculate_manhattan_distance(point_a, point_b)
  (point_a.x - point_b.x).abs + (point_a.y - point_b.y).abs
end

safe_region = 0
map.each do |coordinate, distances|
  map[coordinate] ||= {}
  points.each do |id, point|
    map[coordinate][id] = calculate_manhattan_distance(point,coordinate)
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


Point = Struct.new(:x, :y)

def calculate_manhattan_distance(point_a, point_b)
  (point_a.x - point_b.x).abs + (point_a.y - point_b.y).abs
end

points = File.open('input.txt').map do |point|
  Point.new(*point.split(', ').map(&:to_i))
end

top    = points.min_by { |point| point.y }.y - 1
bottom = points.max_by { |point| point.y }.y + 1
left   = points.min_by { |point| point.x }.x - 1
right  = points.max_by { |point| point.x }.x + 1

map = {}
safe_region = 0

(left..right).each do |x|
  (top..bottom).each { |y| map[Point.new(x,y)] = {} }
end

map.each do |point, distances|
  points.each_with_index do |location, id|
    distances[id] = calculate_manhattan_distance(location,point)
  end

  safe_region +=1 if distances.values.reduce(:+) < 10_000

  max_id, max_value = distances.min_by { |id, value| value }
  if distances.values.count(max_value) > 1
    distances[:min] = nil
  else
    distances[:min] = max_id
  end
end

finite = map.group_by { |point, distances| distances[:min] }.reject do |area, points|
  points.any? do |point, _d|
    [left, right].include?(point.x) || [top, bottom].include?(point.y)
  end
end

id, highest = finite.max_by { |id, points| points.count }
puts "Part 1: #{ highest.count }"
puts "Part 2: #{ safe_region   }"


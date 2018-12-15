require 'pry'
class Point
  attr_accessor :x, :y, :value, :sum

  def initialize(x, y)
    @x = x
    @y = y
    @value = initial_value
    @sum   = integral_value
  end

  def square_value(size)
    return 0 if @x > 300 - size
    return 0 if @y > 300 - size
    a = $grid[@x - 1][@y - 1]
    b = $grid[@x + size - 1][@y - 1]
    c = $grid[@x - 1][@y + size - 1]
    d = $grid[@x + size - 1][@y  + size - 1]
    d.sum - b.sum - c.sum + a.sum
  end

  def initial_value
    rack_id = @x + 10
    hundreds = ((rack_id * @y + $sn) * rack_id).digits[2]
    hundreds - 5
  end

  def integral_value
    return 0 if @x == 0
    return 0 if @y == 0
    a = $grid[@x][@y - 1].sum
    b = $grid[@x - 1][@y].sum
    c = $grid[@x - 1][@y - 1].sum
    a + b + @value - c
  end
end

$sn = 8979
size = 300
$grid = Array.new(size) { Array.new(size, nil) }

(0...size).each do |x|
  (0...size).each do |y|
    $grid[x][y] = Point.new(x, y)
  end
end

#puts $grid.map { |line| line.map{|point| point.value }.join(', ') }.join("\n")
#puts $grid.map { |line| line.map{|point| point.sum }.join(', ') }.join("\n")

valid_points = $grid.flatten.reject { |point| point.x == 0 || point.y == 0 }

max = valid_points.max_by { |point| point.square_value(3) }
puts "Part 1: #{max.x},#{max.y}"

max = valid_points.map do|point|
  [point, (1..300).max_by { |size| point.square_value(size) }]
end.max_by { |point, size| point.square_value(size) }
puts "Part 2: #{max[0].x},#{max[0].y},#{max[1]}"

class Point
  attr_accessor :x, :y, :value

  def initialize(x, y, sn)
    @x = x
    @y = y
    rack_id = @x + 10
    hundreds = ((rack_id * @y + sn) * rack_id).digits[2]
    @value = hundreds - 5
  end
end

class Grid
  attr_accessor :points, :size, :integral_image

  def initialize(size, sn)
    @size   = size
    @points = []
    @integral_image = Array.new(size) { Array.new(size, 0) }

    (1...@size).each do |x|
      (1...@size).each do |y|
        point = Point.new(x, y, sn)
        @points << point
        @integral_image[x][y] = integral_value(point)
      end
    end
  end

  def get_square(x, y, size)
    w = x + size - 1
    h = y + size - 1

    a = @integral_image[x][y]
    b = @integral_image[w][y]
    c = @integral_image[x][h]
    d = @integral_image[w][h]

    [a,b,c,d]
  end

  def integral_value(point)
    a, b, c, d, = get_square(point.x - 1, point.y - 1, 2)
    c + b + point.value - a
  end

  def square_value(point, size)
    a, b, c, d, = get_square(point.x - 1, point.y - 1, size + 1)
    d - b - c + a
  end
end

grid = Grid.new(300, 8979)

max = grid.points.max_by do |point|
  next 0 if [point.x, point.y].max > grid.size - 3
  grid.square_value(point, 3)
end
puts "Part 1: #{max.x},#{max.y}"

max = grid.points.map do |point|
  range = (1..(grid.size - [point.x, point.y].max))
  [point, range.max_by { |size| grid.square_value(point, size) }]
end.max_by do |point, size|
  grid.square_value(point, size)
end

puts "Part 2: #{max[0].x},#{max[0].y},#{max[1]}"

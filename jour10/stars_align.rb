class Point < Struct.new(:x, :y, :vx, :vy)
  def move
    self.x += self.vx
    self.y += self.vy
  end

  def revert
    self.x -= self.vx
    self.y -= self.vy
  end
end

@points = File.open('input.txt').map do |line|
  data = line.match /position=<( *-*\d+), ( *-*\d+)> velocity=<( *-*\d+), ( *-*\d+)>/
  Point.new(*data[1..4].map(&:to_i))
end

def bounding_box
  [Point.new(@points.min_by(&:x).x, @points.min_by(&:y).y), Point.new(@points.max_by(&:x).x, @points.max_by(&:y).y)]
end

def bounding_box_area
  box = bounding_box
  (box[1].x - box[0].x) * (box[1].y - box[0].y)
end

seconds = -1
begin
  seconds += 1
  last_rectangle = bounding_box_area
  @points.each(&:move)
end while(last_rectangle > bounding_box_area)

@points.each(&:revert)

box = bounding_box
output = Array.new (box[1].y - box[0].y + 1) { Array.new((box[1].x - box[0].x + 1), ' ') }

@points.each do |point|
  output[point.y - box[0].y][point.x - box[0].x] = "#"
end

puts "Part 1:"
puts output.map{|v| v.join('') }.join("\n")

puts "Part 2: #{seconds}"

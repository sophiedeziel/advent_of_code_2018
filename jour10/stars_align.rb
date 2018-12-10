require 'pry'
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

@points = File.open('example.txt').map do |line|
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

last_rectangle = nil
nb = 0
begin
  last_rectangle = bounding_box_area
  @points.each(&:move)
  nb += 1
end while(last_rectangle > bounding_box_area)

puts @points.each(&:revert)
puts nb



class Cascade
  attr_accessor :slice, :streams

  SAND = '.'
  WATER = '~'
  CLAY = '#'
  STREAM = '|'

  def initialize(file)
    parse(file)
    source = @slice.index { |x| x[0] == STREAM }
    @streams = [[source, 0]]
  end

  def parse(file)
    clay = []

    File.open(file).each do |line|
      _line, axis, coordinate, *range = line.match(/([xy])=(\d+), [xy]=(\d+)..(\d+)/).to_a
      coordinate = coordinate.to_i
      range = Range.new(*range.map(&:to_i))

      case axis
      when 'x'
        range.to_a.each do |y|
          clay[coordinate] ||= []
          clay[coordinate][y] = CLAY
        end
      when 'y'
        range.to_a.each do |x|
          clay[x] ||= []
          clay[x][coordinate] = CLAY
        end
      end
    end

    @slice = Array.new(clay.count + 1) do
      Array.new clay.max_by { |line| line&.count || 0 }.count, SAND
    end

    clay.each_with_index do |column, x|
      column&.each_with_index do |value, y|
        @slice[x][y] = value if value
      end
    end

    @slice[500][0] = STREAM
    min_x = @slice.index { |column| !column.all? SAND }
    @slice.shift(min_x - 1)
    @slice
  end

  def flow
    x, y = streams.shift

    case slice[x][y + 1]
    when SAND
      make_stream(x, y + 1)
    when WATER, CLAY
      make_stream(x + 1, y) if slice[x + 1][y] == SAND
      make_stream(x - 1, y) if slice[x - 1][y] == SAND
      settle_water(y)
    end
  end

  def settle_water(y)
    x = slice.map { |x| x[y] }.join.index /[#{CLAY}][#{STREAM}]+[#{CLAY}]/
    return unless x
    while slice[x + 1][y] == STREAM do
      slice[x + 1][y] = WATER
      x += 1
      make_stream(x, y - 1) if slice[x][y - 1] == STREAM
    end
  end

  def make_stream(x, y)
    slice[x][y] = STREAM
    streams.push [x, y]
  end

  def count(type)
    slice.sum { |x| x.count(type) }
  end
end

cascade = Cascade.new('input.txt')
while cascade.streams.any? do
  cascade.flow
end

puts "Part 1: #{cascade.count(Cascade::WATER) + cascade.count(Cascade::STREAM)}"
puts "Part 2: #{cascade.count(Cascade::WATER)}"

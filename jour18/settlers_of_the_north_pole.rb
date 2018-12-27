require 'pry'
class Land
  TREE = '|'
  GROUND = '.'
  LUMBERYARD = '#'

  attr_accessor :scan, :known_scans

  def initialize(file)
    @scan = []
    @known_scans = []
    File.open(file).each do |line|
      @scan << line.chomp.chars
    end
    @scan << []
  end

  def cycle(minutes)
    (@known_scans.count...minutes).each do |g|
      if known = @known_scans.index(@scan)
        index = (minutes - @known_scans.count) % (@known_scans.count - known)
        @scan = @known_scans[known + index]
        break
      else
        @known_scans << @scan.map(&:dup)
        minute
      end
    end
  end

  def minute
    new_minute = []
    @scan.each_with_index do |line, y|
      new_minute[y] ||= []
      line.each_with_index do |char, x|
        new_minute[y][x] = evolve(char, y, x)
      end
    end
    @scan = new_minute
  end

  def evolve(char, y, x)
    case char
    when GROUND
      surrounding_points(y, x).count(TREE) >= 3 ? TREE : char
    when TREE
      surrounding_points(y, x).count(LUMBERYARD) >= 3 ? LUMBERYARD : char
    when LUMBERYARD
      points = surrounding_points(y, x)
      (points.count(LUMBERYARD) >= 1 && points.count(TREE) >= 1) ? LUMBERYARD : GROUND
    end
  end

  def surrounding_points(y, x)
    (-1..1).flat_map { |dx| (-1..1).map { |dy| [y + dy, x + dx] } }
      .reject { |dy, dx| dx == x && dy == y }
      .reject { |dy, dx| dx < 0 || dy < 0 }
      .map { |dy, dx| @scan[dy][dx] }
  end

  def ressource_value
    @scan.flatten.count(TREE) * @scan.flatten.count(LUMBERYARD)
  end
end

land = Land.new('input.txt')
land.cycle(10)
puts "Part 1: #{land.ressource_value}"

land.cycle(1000000000)
puts "Part 2: #{land.ressource_value}"

require 'awesome_print'
require 'pry'
require 'fc'

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_sym
    "#{@x}_#{@y}".to_sym
  end

  def ==(other)
    to_sym == other.to_sym
  end
end

class Cavern
  attr_accessor :goblins, :elves, :map, :complete_rounds

  def initialize
    @goblins = []
    @elves   = []
    @map     = []
  end

  def all_units
    @goblins + @elves
  end

  def reading_order(points)
    points.sort_by { |point| [point.y, point.x] }
  end

  def ennemies(unit)
    unit.type == :goblin ? elves : goblins
  end

  def desired_positions(unit)
    ennemies(unit).flat_map do |unit|
      surrounding_points(unit)
    end.select { |ennemy| path?(unit, ennemy) }
  end

  def path?(unit, ennemy)
    distance_per_point = {}
    distance_per_point[unit.to_sym] ||= distance_map(unit)
    return distance_per_point[unit.to_sym][ennemy.x][ennemy.y] != nil
  end

  def nearest(unit, points)
    distances = distance_map(unit)
    potentials = {}
    points.each do |in_range_point|
      steps = distances[in_range_point.x][in_range_point.y]
      potentials[steps] ||= []
      potentials[steps].push in_range_point
    end
    distance = potentials.keys.compact.min
    nearests = potentials[distance]
    reading_order(nearests).first if nearests
  end

  def can_attack(unit)
    ennemies(unit).select do |ennemy|
      (ennemy.x - unit.x).abs + (ennemy.y - unit.y).abs == 1
    end
  end

  def next_step(unit)
    return false if ennemies(unit).empty?

    if can_attack(unit).none?
      target = nearest(unit, desired_positions(unit))
      if target
        step   = nearest(target, surrounding_points(unit))
        unit.move step
      end
    end

    targets = can_attack(unit)
    if targets.any?
      min_hp = targets.map(&:hp).min
      target = reading_order(targets.select { |target| target.hp == min_hp }).first
      target.hp -= 3

      if target.hp <= 0
        elves.delete(target)
        goblins.delete(target)
        @playing.delete(target)
      end
    end
    true
  end

  def occupiable?(x,y)
    @map[x][y] == '.' && all_units.none? { |u| u.x == x && u.y == y }
  end

  def surrounding_points(point)
    [
      (Point.new(point.x, point.y - 1) if occupiable?(point.x, point.y - 1)),
      (Point.new(point.x, point.y + 1) if occupiable?(point.x, point.y + 1)),
      (Point.new(point.x + 1, point.y) if occupiable?(point.x + 1, point.y)),
      (Point.new(point.x - 1, point.y) if occupiable?(point.x - 1, point.y)),
    ].compact
  end

  def distance_map(goal)
    distances = Array.new(@map.size) { Array.new(@map.first.size) }
    to_calculate = FastContainers::PriorityQueue.new(:min)
    to_calculate.push(goal,1)

    distances[goal.x][goal.y] = 1

    while to_calculate.any?
      current_point = to_calculate.pop

      surrounding_points(current_point).each do |point|
        next unless distances[point.x][point.y].nil?

        distance = distances[current_point.x][current_point.y] + 1
        distances[point.x][point.y] = distance
        to_calculate.push(point, distance) unless to_calculate.include? point
      end
    end
    distances
  end

  def round
    @playing = reading_order(all_units)

    while @playing.any?
      unit = @playing.shift
      return false unless next_step(unit)
    end

    @playing.none?
  end
end


class Unit < Point
  attr_accessor :type, :hp

  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
    @hp = 200
  end

  def move(point)
    @x = point.x
    @y = point.y
  end
end

cavern = Cavern.new

input = File.open('input.txt').each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    case char
    when '#', '.'
      cavern.map[x] ||= []
      cavern.map[x][y] = char
    when 'G'
      cavern.map[x] ||= []
      cavern.map[x][y] = '.'
      cavern.goblins << Unit.new(x,y, :goblin)
    when 'E'
      cavern.map[x] ||= []
      cavern.map[x][y] = '.'
      cavern.elves << Unit.new(x,y, :elf)
    end
  end
end

def to_console(cavern)
  map = cavern.map.map(&:dup)
  cavern.all_units.each do |unit|
    map[unit.x][unit.y] = (unit.type == :goblin) ? 'G' : 'E'
  end
  puts map.transpose.map {|line| line.join('') }.join("\n")
end

def play(file)
  cavern = Cavern.new

  input = File.open(file).each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      case char
      when '#', '.'
        cavern.map[x] ||= []
        cavern.map[x][y] = char
      when 'G'
        cavern.map[x] ||= []
        cavern.map[x][y] = '.'
        cavern.goblins << Unit.new(x,y, :goblin)
      when 'E'
        cavern.map[x] ||= []
        cavern.map[x][y] = '.'
        cavern.elves << Unit.new(x,y, :elf)
      end
    end
  end

  rounds = 0
  while cavern.round do
    rounds += 1
    to_console(cavern)
  end

  rounds * cavern.all_units.map(&:hp).sum
end

examples = [
  {file: 'example3.txt', result: 27730},
  {file: 'example4.txt', result: 36334},
  {file: 'example5.txt', result: 39514},
  {file: 'example6.txt', result: 27755},
  {file: 'example7.txt', result: 28944},
  {file: 'example8.txt', result: 18740},
]

# examples.each do |example|
#   outcome = play(example[:file])
#   if outcome == example[:result]
#     puts "."
#   else
#     puts "F"
#   end
# end

outcome = play('input.txt')
puts "Part 1: #{outcome}"

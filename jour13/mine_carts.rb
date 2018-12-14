require 'pry'
require 'awesome_print'

class Cart
  attr_accessor :x, :y, :direction, :next

  def initialize(x, y, direction)
    @x = x
    @y = y
    @direction = direction
    @next = :left
  end

  def move
    rail = $grid[@y][@x]

    directions = { '<' => [-1, 0], '>' => [1, 0], 'v' => [0, 1], '^' => [0, -1] }
    c = directions[@direction]
    @x = x + c[0]
    @y = y + c[1]

    new_rail = $grid[@y][@x]

    case new_rail
    when '+'
      rotate
    when '/', '\\'
      follow_rail(new_rail)
    end
  end

  def rotate
    return turn_left if @next == :left
    return turn_right if @next == :right
    @next = :right
  end

  def follow_rail(new_rail)
    turn = { '\\' => { '<' => '^', '>' => 'v', 'v' => '>', '^' => '<' }, '/' => { '<' => 'v', '^' => '>', '>' => '^', 'v' => '<' } }
    @direction = turn[new_rail][@direction]
  end

  def turn_left
    turn = { '<' => 'v', 'v' => '>', '>' => '^', '^' => '<' }
    @direction = turn[@direction]
    @next = :straight
  end

  def turn_right
    turn = { '<' => '^', 'v' => '<', '>' => 'v', '^' => '>' }
    @direction = turn[@direction]
    @next = :left
  end
end

$grid = []
$carts = []

File.open('input.txt').each_with_index do |line, y|
  $grid << line.split('').each_with_index.map do |char, x|
    case char
    when "<", ">"
      $carts << Cart.new(x,y, char)
      '-'
    when "v", "^"
      $carts << Cart.new(x,y, char)
      '|'
    else
      char
    end
  end
end

first_collition = nil
while($carts.count > 1)
  $carts.sort_by { |cart| [cart.y, cart.x] }.each do |cart|
    cart.move
    current_position = $carts.find_all { |c| c.x == cart.x && c.y == cart.y }
    if current_position.count > 1
      puts "Part 1: #{current_position.first.x},#{current_position.first.y}" if first_collition.nil?
      first_collition ||= cart
      $carts -= current_position
    end
  end
end

puts "Part 2: #{$carts.first.x},#{$carts.first.y}"


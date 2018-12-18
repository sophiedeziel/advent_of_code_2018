require 'pry'

input = 509671

class Chart
  attr_accessor :recipes, :elf1, :elf2

  def initialize
    @recipes = [3,7]
    @elf1 = 0
    @elf2 = 1
    combine_recipes
  end

  def turn
    combine_recipes
    move
  end

  def combine_recipes
    sum = @recipes[@elf1] + @recipes[@elf2]
    sum.digits.reverse.each { |new_recipe| @recipes.push new_recipe }
  end

  def move
    @elf1 = (@elf1 + @recipes[@elf1] + 1) % @recipes.size
    @elf2 = (@elf2 + @recipes[@elf2] + 1) % @recipes.size
  end
end

chart = Chart.new

input.times do
  chart.turn
end

part1 = chart.recipes.dup.shift(input)
puts "Part 1: #{part1.shift(10).join('')}"

match = nil
chart = Chart.new
number = 0
while(match.nil?)
  10_000_000.times do
    number += 1
    chart.turn
  end
  match = chart.recipes.join('').match /(\d+)#{input}/
end
puts "Part 2: #{match[1].size}"

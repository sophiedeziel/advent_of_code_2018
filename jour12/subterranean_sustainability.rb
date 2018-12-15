class GameOfLife
  attr_accessor :rules, :pots

  def initialize
    @rules = {}
    @pots = {}
  end

  def cycle(generations)
    known_sequences = []
    score = 0

    (1..generations).each do |g|
      evolve

      score = calc_score(@pots)
      if known = known_sequences.find { |sequence| sequence.values == @pots.values }
        score = score + (generations - g) * (score - calc_score(known))
        break
      else
        known_sequences << @pots.dup
      end
    end
    score
  end

  def evolve
    new_gen = {}

    clean
    @pots.each do |pot, state|
      l2 = @pots[pot - 2] || false
      l1 = @pots[pot - 1] || false

      r1 = @pots[pot + 1] || false
      r2 = @pots[pot + 2] || false

      neighbors  = [l2, l1, state, r1, r2]
      new_gen[pot] = @rules[neighbors]
    end

    @pots = new_gen
  end

  def calc_score(generation)
    generation.map { |k,v| k if v }.compact.sum
  end

  def clean
    first = @pots.keys.min
    @pots[first - 1] = false if @pots[first]
    @pots.delete(first) unless @pots[first] || @pots[first + 1]

    last = @pots.keys.max
    @pots[last + 1] = false if @pots[last]
    @pots.delete(last) unless @pots[last] || @pots[last - 1]
  end
end

game = GameOfLife.new

File.open('input.txt').each do |line|
  key = line[0...5].split('').map { |char| char == '#' }
  game.rules[key] = line[9] == '#'
end

initial_state = '#.##.###.#.##...##..#..##....#.#.#.#.##....##..#..####..###.####.##.#..#...#..######.#.....#..##...#'
initial_state.split('').each_with_index do |char, index|
  value = char == '#'
  game.pots[index] = value
end

puts "Part 1: #{game.cycle(20)}"
puts "Part 2: #{game.cycle(50000000000)}"


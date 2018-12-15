require 'pry'

initial_state = '.#.##.###.#.##...##..#..##....#.#.#.#.##....##..#..####..###.####.##.#..#...#..######.#.....#..##...#'

rules  = {}
states = {}

File.open('input.txt').each do |line|
  key = line[0...5].split('').map { |char| char == '#' }
  rules[key] = line[9] == '#'
end

initial_state.split('').each_with_index do |char, index|
  value = char == '#'
  states[index - 1] = value
end

known_sequences = []

(1..50000000000).each do |g|
  new_gen = {}
  states.each do |pot, state|
    l2 = states[pot - 2] || false
    l1 = states[pot - 1] || false

    r1 = states[pot + 1] || false
    r2 = states[pot + 2] || false

    neighbors  = [l2, l1, state, r1, r2]
    new_gen[pot] = rules[neighbors] || false
  end
  last = new_gen.max_by { |k,v| k }
  new_gen[last[0] + 1] = false if new_gen[last[0]]

  first = new_gen.min_by { |k,v| k }
  if new_gen[first[0]]
    new_gen[first[0] - 1] = false
  else
    new_gen.delete(first[0]) unless new_gen[first[0] + 1]
  end

  this_score = new_gen.select { |k,v| v }.map { |k,v| k }.sum
  puts "Part 1: #{this_score}" if g == 20

  if known = known_sequences.find { |sequence| sequence.values == new_gen.values }
    last_score = known.select { |k,v| v }.map { |k,v| k }.sum
    puts "Part 2: #{this_score + (50000000000 - g) * (this_score - last_score)}"
    break
  else
    known_sequences << new_gen
  end

  states = new_gen
end




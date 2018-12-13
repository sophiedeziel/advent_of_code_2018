require 'pry'

initial_state = '........#.##.###.#.##...##..#..##....#.#.#.#.##....##..#..####..###.####.##.#..#...#..######.#.....#..##...#.......'

rules  = {}
states = {}

File.open('input.txt').each do |line|
  key = line[0...5].split('').map { |char| char == '#' }
  rules[key] = line[9] == '#'
end

initial_state.split('').each_with_index do |char, index|
  value = char == '#'
  states[index - 8] = value
end

puts "   " + states.map {|k, v| k % 10 == 0 ? k.digits.last : ' '}.compact.join('')
puts "0: " + states.map {|k, v| k < -2 ? nil : v ? '#' : '.'}.compact.join('')

(1..20).each do |g|
  new_gen = {}
  states.each do |pot, state|
    new_gen[pot - 2] ||= false
    new_gen[pot - 1] ||= false

    new_gen[pot + 1] ||= false
    new_gen[pot + 2] ||= false

    l2 = states[pot - 2] || false
    l1 = states[pot - 1] || false

    r1 = states[pot + 1] || false
    r2 = states[pot + 2] || false

    neighbors  = [l2, l1, state, r1, r2]
    new_gen[pot] = rules[neighbors] || false
  end
  states = new_gen
  puts g.to_s + ": " + states.map {|k, v|  v ? '#' : '.'}.compact.join('')
end


puts "Part 1: #{states.select { |k,v| v }.map { |k,v| k }.sum}"


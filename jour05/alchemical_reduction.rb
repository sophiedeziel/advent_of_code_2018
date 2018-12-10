input = File.read('input.txt').delete("\n")

def reduce_polymer(input_string)
  reduced_polymer = []
  input_string.each_char do |char|
    last = reduced_polymer.pop

    next if last&.downcase == char.downcase && last != char

    reduced_polymer.push last if last
    reduced_polymer.push char
  end

  reduced_polymer.size
end

def optimized_polymer(input)
  polymers = ('a'...'z').map do |unit|
    test_string = input.dup.delete(unit).delete(unit.upcase)
    reduce_polymer(test_string)
  end
  polymers.min
end

puts "Part 1 #{reduce_polymer(input)}"
puts "Part 2 #{optimized_polymer(input)}"

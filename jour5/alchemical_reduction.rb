final_string = []
input = File.read('input.txt').delete("\n")

def reduce_polymer(input_string)
  final_string = []
  input_string.each_char do |char|
    last = final_string.pop

    next if last&.downcase == char.downcase && last != char

    final_string.push last if last
    final_string.push char
  end

  final_string.size
end

def optimized_polymer(input)
  polymers = ('a'...'z').map do |unit|
    test_string = input.dup
    test_string.delete!(unit)
    test_string.delete!(unit.upcase)

    reduce_polymer(test_string)
  end
  polymers.min
end

puts "Part 1 #{reduce_polymer(input)}"
puts "Part 2 #{optimized_polymer(input)}"

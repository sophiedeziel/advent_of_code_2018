final_string = []
input = File.read('input.txt').to_s.tap {|s| s.gsub!("\n", '')}

def reduce_polymer(input_string)
  final_string = []
  input_string.each_char do |char|
    last = final_string.pop

    next if last&.downcase == char.downcase && last != char

    final_string.push last if last
    final_string.push char
  end

  final_string.join.size
end

experiments = ('a'...'z').map do |unit|
  test_string = input.dup
  test_string.gsub!(unit, '')
  test_string.gsub!(unit.upcase, '')

  reduce_polymer(test_string)
end

puts "Part 1 #{reduce_polymer(input)}"
puts "Part 2 #{experiments.min}"

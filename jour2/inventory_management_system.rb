lines = File.open('input.txt', 'r').map(&:to_s)

double_count = 0
triple_count = 0

lines.each do |line|
  counts = {}
  line.chars.each do |letter|
    counts[letter] = (counts[letter] || 0) + 1
  end

  double_count += 1 if counts.any? { |_key, value| value == 2 }
  triple_count += 1 if counts.any? { |_key, value| value == 3 }
end

puts "Part 1: #{double_count * triple_count}"

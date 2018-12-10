lines = []
boxes_ids = ''

def compare(string1, string2)
  differences = 0
  string1.chars.each_with_index do |char, i|
    differences += 1 if char != string2[i]
  end
  differences
end

File.open('input.txt', 'r').each do |line|
  similar = lines.find { |saved_line| compare(line, saved_line) == 1 }
  if similar
    line.chars.each_with_index do |value, i|
      boxes_ids += value if value == similar[i]
    end
  end
  lines << line
end

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
puts "Part 2: #{boxes_ids}"


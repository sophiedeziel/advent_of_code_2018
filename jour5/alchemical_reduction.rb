final_string = []

File.open('input.txt', 'r').each_char do |char|
  last = final_string.pop

  next if last&.downcase == char.downcase && last != char

  final_string.push last if last
  final_string.push char if char != "\n"
end

puts "Part 1 #{final_string.join.size }"

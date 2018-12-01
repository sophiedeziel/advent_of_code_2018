frequency = 0
File.open('input.txt', 'r').each { |line| frequency += line.to_i }
puts frequency

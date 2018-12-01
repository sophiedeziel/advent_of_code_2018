frequency = 0
frequency_history = [0]
double = nil
first_run = true

while(double.nil?) do
  File.open('input.txt', 'r').each do |line|
    frequency += line.to_i
    if frequency_history.include? frequency
      double = frequency
      break
    end
    frequency_history << frequency
  end

  puts "Part 1: #{frequency}" if first_run
  first_run = false
end

puts "Part 2: #{double}"

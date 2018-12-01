frequency = 0
frequency_history = {0 => true}
double = nil
first_run = true

lines = File.open('input.txt', 'r').map { |line| line }
#lines = File.open('input.txt', 'r')

while(double.nil?) do
  lines.each do |line|
    frequency += line.to_i
    if frequency_history.has_key? frequency
      double = frequency
      break
    end
    frequency_history.merge! Hash[frequency, true]
  end

  puts "Part 1: #{frequency}" if first_run
  first_run = false
end

puts "Part 2: #{double}"

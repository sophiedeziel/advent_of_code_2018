frequency = 0
frequency_history = {0 => true}
double = nil
first_run = true

# on ouvre le fichier et on le place en mémoire
lines = File.open('input.txt', 'r').map { |line| line }

# on exécute tant qu'on n'a pas trouvé un doublon
while(double.nil?) do
  lines.each do |line|
    frequency += line.to_i

    # On sort de la boucle si on trouve un doublon dans la liste
    if frequency_history.has_key? frequency
      double = frequency
      break
    end

    # On insère le résultat dans la liste
    frequency_history.merge! Hash[frequency, true]
  end

  puts "Part 1: #{frequency}" if first_run
  first_run = false
end

puts "Part 2: #{double}"

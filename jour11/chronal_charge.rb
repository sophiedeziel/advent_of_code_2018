require 'pry'
input = 8979

size = 300

@grid = Array.new(size) { Array.new(size, {}) }

(1..size).to_a.reverse_each do |x|
  (1..size).to_a.reverse_each do |y|

    rack_id = x + 10
    hundreds = ((rack_id * y + input) * rack_id).digits[2]
    @grid[x - 1][y - 1] =
      {
        value: hundreds - 5,
        x: x,
        y: y,
        sum: {}
      }

    (1..20).each do |n|
      if (y <= size - (n-1)) && (x <= size - (n-1))
        @grid[x - 1][y - 1][:sum][n] = (x..(x + (n-1))).flat_map { |ax| (y..(y + (n-1))).map { |ay| @grid[ax - 1][ay - 1][:value] } }.sum
      end
    end
  end
end

#puts @grid.map { |line| line.map{|hash| hash[:value]}.join(', ') }.join("\n")

max = @grid.flatten.max_by { |hash| hash[:sum][3] || 0 }
#puts max
puts "Part 1: #{max[:x]},#{max[:y]}"

max = @grid.flatten.max_by { |hash| hash[:sum].max_by{ |k, v| v }[1] || 0 }
puts "Part 2:"
puts max

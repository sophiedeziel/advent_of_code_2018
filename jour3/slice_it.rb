fabric = {}
overlaps = 0

def parse_claim(string)
  data = string.match(/#(?<id>\d+) @ (?<position>\d+,\d+): (?<size>\d+x\d+)/)
  x,y = data[:position].split(',').map(&:to_i)
  width, height = data[:size].split('x').map(&:to_i)
  [x, y, width, height]
end

File.open('input.txt', 'r').each do |line|
  x, y, width, height = parse_claim(line)
  (0...width).each do |rect_x|
    (0...height).each do |rect_y|
      fabric[x + rect_x] = {} if fabric[x + rect_x].nil?
      if fabric.dig(x + rect_x, y + rect_y).nil?
        fabric[x + rect_x][y + rect_y] = 1
      else
        overlaps += 1 if fabric[x + rect_x][y + rect_y] == 1
        fabric[x + rect_x][y + rect_y] +=1
      end
    end
  end
end

puts "Part 1: #{overlaps}"

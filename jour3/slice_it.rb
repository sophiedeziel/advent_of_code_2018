fabric = {}
overlaps = 0

def parse_claim(string)
  data = string.match(/#(?<id>\d+) @ (?<position>\d+,\d+): (?<size>\d+x\d+)/)
  id = data[:id]
  x,y = data[:position].split(',').map(&:to_i)
  width, height = data[:size].split('x').map(&:to_i)
  [id, x, y, width, height]
end

claims = File.open('input.txt', 'r').map do |line|
  parse_claim(line)
end

claims.each do |_id,x,y,width,height|
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

good_claim = claims.find do |id,x,y,width,height|
  rectangle = (0...width).map do |rect_x|
    (0...height).map do |rect_y|
      fabric.dig(x + rect_x, y + rect_y)
    end
  end
  rectangle.flatten.all? 1
end

puts "Part 1: #{overlaps}"
puts "Part 2: #{good_claim.first}"

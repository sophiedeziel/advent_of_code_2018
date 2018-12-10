fabric = {}
overlaps = 0

def parse_claim(string)
  data = string.match(/#(?<id>\d+) @ (?<position>\d+,\d+): (?<size>\d+x\d+)/)
  id = data[:id]
  x,y = data[:position].split(',').map(&:to_i)
  width, height = data[:size].split('x').map(&:to_i)
  [id, x, y, width, height]
end

def list_coordinates(x,y,width,height)
  (x...(x+width)).flat_map do |x|
    (y...(y+height)).map do |y|
      x.to_s + 'x' + y.to_s
    end
  end
end

claims = File.open('input.txt', 'r').map do |line|
  parse_claim(line)
end

claims.each do |_id,x,y,width,height|
  list_coordinates(x,y,width,height).each do |key|
    if fabric[key].nil?
      fabric[key] = 1
    else
      overlaps += 1 if fabric[key] == 1
      fabric[key] +=1
    end
  end
end

good_claim = claims.find do |id,x,y,width,height|
  rectangle = list_coordinates(x,y,width,height).map do |key|
    fabric[key]
  end
  rectangle.flatten.all? 1
end

puts "Part 1: #{overlaps}"
puts "Part 2: #{good_claim.first}"

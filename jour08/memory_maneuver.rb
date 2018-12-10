class Node < Struct.new(:nb_children, :nb_metadata, :children, :metadata)
  def value
    return metadata.reduce(:+) if nb_children == 0

    sum = 0
    metadata.each do |index|
      next unless children[index-1]
      sum += children[index-1].value
    end
    sum
  end
end

def parse_node(array)
  node = Node.new(array.shift, array.shift, [], [])

  node.nb_children.times do
    node.children << parse_node(array)
  end

  node.metadata = array.shift(node.nb_metadata)
  @total += node.metadata.reduce(:+)

  node
end

input = File.read('input.txt').split.map(&:to_i)

@total = 0
root = parse_node(input)

puts "Part 1: #{ @total }"
puts "Part 2: #{ root.value }"

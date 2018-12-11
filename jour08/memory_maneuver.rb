class Node < Struct.new(:nb_children, :nb_metadata, :children, :metadata)
  def value
    return metadata.sum if nb_children == 0

    metadata.map { |index| children[index - 1]&.value }.compact.sum
  end
end

input = File.read('input.txt').split.map(&:to_i)

def parse_node(array)
  node = Node.new(array.shift, array.shift, [], [])

  node.nb_children.times do
    node.children << parse_node(array)
  end

  node.metadata = array.shift(node.nb_metadata)

  @total += node.metadata.sum
  node
end

@total = 0

root = parse_node(input)

puts "Part 1: #{ @total }"
puts "Part 2: #{ root.value }"

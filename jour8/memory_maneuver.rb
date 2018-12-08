require 'pry'

class Node
  attr_accessor :nb_children, :nb_metadata, :children, :metadata
  def initialize(nb_children, nb_metadata, children, metadata)
    @nb_children, @nb_metadata, @children, @metadata = nb_children, nb_metadata, children, metadata
  end

  def value
    if @nb_children == 0
      @metadata.reduce(:+)
    else
      sum = 0
      @metadata.each do |index|
        next unless @children[index-1]
        sum += @children[index-1].value
      end
      sum
    end
  end
end

input = File.read('input.txt').split.map(&:to_i)

def get_node(array)
  node = Node.new(0, 0, [], [])
  node.nb_children = array.shift
  node.nb_metadata = array.shift

  node.nb_children.times do
    node.children << get_node(array)
  end

  node.metadata =  array.shift(node.nb_metadata)
  @total += node.metadata.reduce(:+)

  node
end

@total = 0
root = get_node(input)

puts "Part 1: #{ @total }"
puts "Part 2: #{ root.value }"


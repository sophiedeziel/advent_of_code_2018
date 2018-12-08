require 'pry'
require 'awesome_print'
Node = Struct.new(:id, :children)

@nodes = {}
@answer = ''
@workers = {}
(1..5).each do |worker|
  @workers[worker] = {current: nil, time: 0}
end

File.open('input.txt').each do |line|
  id    = line[5]
  child = line[36]

  @nodes[id]    ||= Node.new(id, [])
  @nodes[child] ||= Node.new(child, [])

  @nodes[id].children << child
  @nodes[id].children.sort!.reverse!
end

def available_nodes
  @nodes.reject do |id, node|
    @nodes.any? { |_id, n| n.children.include? id } || @workers.any? { |_id, worker| worker[:current] == id }
  end
end

def available_workers
  @workers.select { |k,v| v[:current].nil? }
end

def assign_tasks
  available_workers.each do |id, worker|
    available = available_nodes.sort_by {|id, node| id }
    worker[:current] = available.first[0] unless available.empty?
  end
end

def mark_as_done(node_id)
  @answer += node_id
  @nodes.delete(node_id)
  @nodes.each do |key, node|
    node.children.delete(node_id)
  end
end

def work(worker)
  worker[:time] += 1
  if worker[:time] >= worker[:current].ord - 4
    mark_as_done(worker[:current])
    worker[:current] = nil
    worker[:time]    = 0
  end
end

total_time = 0
while @nodes.any?
  total_time += 1
  assign_tasks
  @workers.reject{|id, worker| worker[:current].nil?}.each do |id, worker|
    work(worker)
  end
end

puts "Part 1: #{@answer}"
puts "Part 2: #{total_time}"

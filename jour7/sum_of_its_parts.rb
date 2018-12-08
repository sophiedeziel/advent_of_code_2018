require 'pry'
require 'awesome_print'
Node = Struct.new(:id, :children)
@nodes = {}

File.open('input.txt').each do |line|
  id    = line[5]
  child = line[36]

  @nodes[id]    ||= Node.new(id, [])
  @nodes[child] ||= Node.new(child, [])

  @nodes[id].children << child
  @nodes[id].children.sort!.reverse!
end

@answer = ''

def available_nodes
  @nodes.reject do |id, node|
    @nodes.any? { |_id, n| n.children.include? id } || @workers.any? { |_id, worker| worker[:current] == id }
  end
end

def available_workers
  @workers.select { |k,v| v[:current].nil? }
end

@workers = {}
min_time = 60
(1..5).each do |worker|
  @workers[worker] = {current: nil, time: 0}
end

current_second = 0

def assign_tasks
  available_workers.each do |id, worker|
    available = available_nodes.sort_by {|id, node| id }
    worker[:current] = available.first[0] unless available.empty?
  end
end

while @nodes.any?
  current_second += 1
  assign_tasks

  @workers.each do |id, worker|
    if worker[:current]
      worker[:time] += 1
      if worker[:time] >= (min_time + worker[:current].ord - 64)
        @answer += worker[:current]
        @nodes.delete(worker[:current])
        @nodes.each do |key, node|
          node.children.delete(worker[:current])
        end
        worker[:current] = nil
        worker[:time]    = 0
      end
    end
  end
end

puts "Part 1: #{@answer}"
puts "Part 2: #{current_second}"

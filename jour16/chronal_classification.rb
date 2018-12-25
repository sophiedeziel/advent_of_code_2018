require 'pry'
class Computer
  attr_accessor :registers

  def initialize(registers)
    @registers = registers
  end

  # Addition
  def addr(a,b,c)
    @registers[c] = @registers[a] + @registers[b]
  end

  def addi(a,b,c)
    @registers[c] = @registers[a] + b
  end

  # Multiplication
  def mulr(a,b,c)
    @registers[c] = @registers[a] * @registers[b]
  end

  def muli(a,b,c)
    @registers[c] = @registers[a] * b
  end

  # Bitwise AND
  def bandr(a,b,c)
    @registers[c] = @registers[a] & @registers[b]
  end

  def bandi(a,b,c)
    @registers[c] = @registers[a] & b
  end

  # Bitwise OR
  def borr(a,b,c)
    @registers[c] = @registers[a] | @registers[b]
  end

  def bori(a,b,c)
    @registers[c] = @registers[a] | b
  end

  # Assignment
  def setr(a,b,c)
    @registers[c] = @registers[a]
  end

  def seti(a,b,c)
    @registers[c] = a
  end

  # Greater-than testing
  def gtir(a,b,c)
    @registers[c] = a > @registers[b] ? 1 : 0
  end

  def gtri(a,b,c)
    @registers[c] = @registers[a] > b ? 1 : 0
  end

  def gtrr(a,b,c)
    @registers[c] = @registers[a] > @registers[b] ? 1 : 0
  end

  #Equality testing
  def eqir(a,b,c)
    @registers[c] = a == @registers[b] ? 1 : 0
  end

  def eqri(a,b,c)
    @registers[c] = @registers[a] == b ? 1 : 0
  end

  def eqrr(a,b,c)
    @registers[c] = @registers[a] == @registers[b] ? 1 : 0
  end
end

instructions = []
program_lines = []

input = File.open('input.txt').each_slice(4) do |lines|
  if lines.first.include? "Before"
    instruction = {
      before: lines[0].scan(/(\d+)/).map { |n| n.join('').to_i },
      after: lines[2].scan(/(\d+)/).map { |n| n.join('').to_i },
      operation: lines[1].scan(/(\d+)/).map { |n| n.join('').to_i },
      potential_operators: []
    }
    instructions << instruction
  else
    lines.each { |l| program_lines << l.scan(/(\d+)/).map { |n| n.join('').to_i } }
  end
end

instructions.each do |instruction|
  %w[addi addr bandi bandr bori borr eqir eqri eqrr gtir gtri gtrr muli mulr seti setr].each do |operation|
    test_case = Computer.new(instruction[:before].dup)
    test_case.send(operation, *instruction[:operation][1..3])
    if test_case.registers == instruction[:after]
      instruction[:potential_operators] << operation
    end
  end
end

matching = instructions.select do |instruction|
  instruction[:potential_operators].count >= 3
end

puts "Part 1 #{matching.count}"




require 'pry'

# Partiquement la même classe que dans le défi 16
class Computer
  attr_accessor :registers, :instructions, :ip

  def initialize(registers)
    @registers = registers
    @instructions = []
  end

  def clock
    instruction = @instructions[@registers[@ip]]
    return false if instruction.nil?
    send(*instruction)
    @registers[@ip] += 1
    true
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
    @registers[c] = (a == @registers[b] ? 1 : 0)
  end

  def eqri(a,b,c)
    @registers[c] = (@registers[a] == b ? 1 : 0)
  end

  def eqrr(a,b,c)
    @registers[c] = (@registers[a] == @registers[b] ? 1 : 0)
  end
end

computer = Computer.new(Array.new(6, 0))

file = File.open('input.txt')
computer.ip = file.first.scan(/(\d+)/).join.to_i

file.each do |line|
  name, *args = line.chomp.split
  args = args.map &:to_i
  computer.instructions << [name, *args]
end

clocks = 0
while computer.clock do
  clocks += 1
end
puts computer.registers.join(', ')

puts "Part 1: #{computer.registers[0]}"

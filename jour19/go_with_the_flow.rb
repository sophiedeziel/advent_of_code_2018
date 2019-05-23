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

    if @registers[@ip] == 2 && @registers[5] != 0
      vm_optimization_2
    else
      send(*instruction)
    end
    return false if @registers[@ip] < 0
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

  # 1  seti 1 5 1   R1 = 1
  # 2  seti 1 2 2   R2 = 1
  # 3  mulr 1 2 3   R3 = R1 * R2
  # 4  eqrr 3 5 3   R3 = R3 == R5
  # 5  addr 3 4 4   IP = R3 + IP
  # 6  addi 4 1 4   IP = IP + 1
  # 7  addr 1 0 0   R0 = R1 + R0
  # 8  addi 2 1 2   R2 = R2 + 1
  # 9  gtrr 2 5 3   R3 = R2 > R5
  # 10 addr 4 3 4   IP = IP + R3
  # 11 seti 2 7 4   IP = 2
  # 12 addi 1 1 1   R1 += 1
  # 13 gtrr 1 5 3   R3 = R1 > R5
  # 14 addr 3 4 4   IP = R3 + IP
  # 15 seti 1 9 4   IP = 1

  # R1 = 1
  # do
  #   R2 = 1
  #   do
  #     if R1 * R2 == R5   * R1 et R2 doivent être des facteurs de R5
  #       R0 += R1         * ils sont additionnés entre eux,
  #     end
  #     R2 += 1
  #   end while R2 < R5
  #
  #   R1 += 1
  # end while R1 < R5

  # Cette implémentation du calcul est totalement du au fait que
  # cet ordinateur fictif n'a que 6 registers et ne dispose pas plus de mémoire
  # Nous avons une machine virtuelle qui peut magiquement lui en donner
  def vm_optimization_2
    puts "optimizing"
    @registers[0] = 0
    @registers[5].times do |i|
      @registers[0] += (i + 1) if @registers[5] % (i+1) == 0
    end

    @registers[@ip] = 15
  end
end



computer = Computer.new(Array.new(6, 0))

file = File.open('input.txt')
computer.ip = file.first.scan(/(\d+)/).join.to_i

instructions = []

file.each do |line|
  name, *args = line.chomp.split
  args = args.map &:to_i
  computer.instructions << [name, *args]
end

while computer.clock do; end
puts "Part 1: #{computer.registers[0]}"

computer.registers = [1,0,0,0,0,0]

while computer.clock do; end
puts "Part 2: #{computer.registers[0]}"

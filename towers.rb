require 'pry'
require 'pry-nav'

def valid_input
  print "Enter move > "
  input = $stdin.gets.chomp
  from_input = input[0].to_i
  to_input = input[-1].to_i

  if from_input.between?(1,3) && from_input.between?(1,3)
    from_tower = from_input
    to_tower = to_input
    legal_move(from_tower, to_tower)
  elsif input == "q"
    puts "Game Over"
    exit
  else
    system "clear"
    puts "invalid input"
    play
  end
end


def move_disk(from,to)
  @towers[to] << @towers[from][-1]
  @towers[from].pop
  system "clear"
  play
end


def legal_move(from,to)
  if @towers[to].empty?
    move_disk(from,to)
  elsif @towers[from][-1] < @towers[to][-1]
    move_disk(from,to)
  else
    system "clear"
    puts "illegal move"
  end
end


def new(height=3)
  system "clear"
  tower1 = (1..height).to_a.reverse
  tower2 = []
  tower3 = []
  @towers = [nil, tower1, tower2, tower3]
  @height = height
  play
end


def player_won?
  if @towers[1].empty? && @towers[2].empty?
    puts "YOU WIN!"
    exit
  else
    return false
  end
end

def play

  until player_won?

    print "\n"
    print "\n"
    print @towers[1]
    print "\n"
    print @towers[2]
    print "\n"
    print @towers[3]
    print "\n"

    # (@height-1).downto(0) do |disk|
    #   (1..3).each do |tower_num|
    #     if @towers[tower_num][disk].nil?
    #       print " " * @height
    #     else
    #       print ("o" * @towers[tower_num][disk]).rjust(@height)
    #     end
    #     print " | "
    #   end
    #   print "\n"
    # end

    valid_input

  end
end

height = ARGV[0].to_i
new(height)
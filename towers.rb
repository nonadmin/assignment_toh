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
    puts "\nGame Over!"
    exit
  else
    return "Invalid Input!"
  end
end


def move_disk(from,to)
  @towers[to] << @towers[from][-1]
  @towers[from].pop
end


def legal_move(from,to)
  if @towers[from].empty?
    return "Nothing To Move!"
  elsif @towers[to].empty?
    move_disk(from,to)
  elsif @towers[from][-1] < @towers[to][-1]
    move_disk(from,to)
  else
    return "Illegal Move!"
  end
end


def setup_game(height)
  system "clear"
  tower1 = (1..height).to_a.reverse
  tower2 = []
  tower3 = []
  @towers = [nil, tower1, tower2, tower3]
  @height = height
  play_loop
end

def print_board
    puts "Towers of Hanoi\n\n"
    (@height-1).downto(0) do |disk|
      (1..3).each do |tower_num|
        if @towers[tower_num][disk].nil?
          print " " * @height
        else
          print ("o" * @towers[tower_num][disk]).rjust(@height)
        end
        print " | "
      end
      print "\n"
    end
    print "1".rjust(@height)
    print " | "
    print "2".rjust(@height)
    print " | "
    print "3".rjust(@height)
    print " | "
    puts "\n\nEnter where you'd like to move from and to"
    puts "in the format '1,3' or simply '13'."
    puts "Enter 'q' to quit.\n\n"
end


def player_won?
  if @towers[1].empty? && @towers[2].empty?
    return "YOU WIN!"
  else
    return false
  end
end

def play_loop

  # Main loop that other functions return to,
  # Prints error messages returned by the other functions, if any.

  feedback = nil

  until player_won?

    system "clear"
    puts feedback unless feedback.class == Fixnum
    print_board
    feedback = valid_input

  end

  system "clear"
  puts feedback
  print_board
end

def start
  if ARGV.empty?
    height = 3
  else
    height = ARGV[0].to_i
  end

  setup_game(height)
end

start
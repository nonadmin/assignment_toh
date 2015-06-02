require 'pry'
require 'pry-nav'



# Check command line arguments to see if player has specified
# a tower size, if not we use the default of "3".
def start
  if ARGV.empty?
    height = 3
  else
    height = ARGV[0].to_i
  end

  setup_game(height)
end



# After checking the command line we go ahead and establish
# some global variables that a lot of the other methods will need.
# The tower disks are just integers in an array, which makes it easy
# to compare and move them around.
def setup_game(height)
  tower1 = (1..height).to_a.reverse
  tower2 = []
  tower3 = []
  @towers = [nil, tower1, tower2, tower3]
  @height = height
  play_loop
end



# Main loop that other functions return to,
# Prints error messages returned by the other functions, if any.  
def play_loop
  message = nil
  loop do

    # Start with the print board method and also puts
    # any messages returned by the other methods
    print_board
    puts ">> #{message}"

    if player_won?
      puts "YOU WON!"
      exit
    else
      # Player hasn't won, yet, so we need to see what to do next.
      input = valid_input

      # if valid_input returns an array we can assume its a move
      # if it returns "quit" the player entered q
      # anything else is an error message that we'll display
      if input.class == Array
          message = legal_move(input)
        elsif input == "quit"
          puts "Game Over :("
          exit
        else
          message = input
      end
    end

  end
end



# Getting input from the player, decided that basically anything
# that began and ended in numbers between 1 and 3 is ok so we 
# check the [0] and [-1] values of the player's input
def valid_input
  print "Enter move > "
  input = $stdin.gets.chomp

  from_input = input[0].to_i
  to_input = input[-1].to_i

  if from_input.between?(1,3) && to_input.between?(1,3)
    return [from_input, to_input]
  elsif input == "q"
    return "quit"
  else
    return "Invalid Input!"
  end
end



# We've established the input is a valid move, but we don't know if its 
# legal according to the game rules.  Here we make sure the disk is either
# being moved on top of a larger disk or to an empty tower.  Also that we're not
# trying to move from an empty tower.
def legal_move(array)
  from, to = array[0], array[1]
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



# Simple method to move the disks, returns nil so the main loop won't print
# anything as a message to the player.
def move_disk(from,to)
  @towers[to] << @towers[from][-1]
  @towers[from].pop
  nil
end



# The method to display the current board to the player
# Uses our global @height variable for alignment and tower layout
def print_board
    system "clear"
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
    puts "\n\nEnter where you'd like to move from and"
    puts "to in the format '1,3' or simply '13'."
    puts "Enter 'q' to quit.\n"
end


# Simple method to check if towers 1 and 2 are empty, meaning the player
# has won.
def player_won?
  if @towers[1].empty? && @towers[2].empty?
    return true
  else
    return false
  end
end


start
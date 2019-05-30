require_relative "./bestnotes/Category"
require_relative "./bestnotes/Note"
require_relative "./bestnotes/User"

require "yaml"
require "io/console"
require "prawn"
require "readline"
require "tty-screen"

# Ensures text displays correctly on terminals of any size
def print(str, is_puts = false)
  screen_width = TTY::Screen.size[1]
  words = str.split(/ /)
  trail_space = str[/ +$/]
  words[words.length - 1] = words[words.length - 1] + trail_space unless trail_space.nil?

  line_arr = words.each_with_object([""]) { |word, lines|
    index = lines.length - 1
    prev_newline = lines[index].rindex("\n")
    if lines[index].length - (prev_newline.nil? ? 0 : prev_newline + 1) + word.length + 1 > screen_width
      lines.push(word)
    elsif lines[index].empty?
      lines[index] = word
    elsif lines[index].length == prev_newline
      lines[index] = lines[index] + word
    else
      lines[index] = lines[index] + " " + word
    end
  }
  # p line_arr
  new_str = ""
  all_but_last = line_arr.length == 1 ? nil : line_arr.slice(0..line_arr.length - 2)
  all_but_last&.each { |line| new_str.concat(line, "\n") }
  new_str.concat(line_arr[line_arr.length - 1])

  new_str.concat("\n") if is_puts

  super(new_str)
end

def puts(str)
  print(str, true)
end

def main_dialogue(storage)
  storage_path = File.dirname(__FILE__) << "/../#{storage}"

  # Loads stored users arary into memory else initialises empty array and creates a file for it to be stored in
  if File.exist?(storage_path)
    users = YAML.safe_load(File.read(storage_path), [User, Category, Note, Time])
  else
    users = []
    File.open(storage_path, "w+") { |file| file.write(users.to_yaml) }
  end

  # Updates the users array based on activity within the session.
  users = bestnotes_ui(users)


  File.open(storage_path, "w+") { |file| file.write(users.to_yaml) }
end

# Accepts users array and returns updated users on recieving user input to quit.
def bestnotes_ui(users)
  selected_user = nil

  loop do
    while selected_user.nil?
      print "\e[H\e[2J"
      puts "Welcome to BestNotes!"
      if users.empty?
        puts "No accounts found!"
      else
        print "Press (l) to login, (r) to register or (q) to quit.\n"
        auth_menu_entry = Readline.readline("> ").strip.downcase
      end

      if users.empty? || auth_menu_entry == "r"
        new_user_id = users.length + 1
        new_user = add_user(new_user_id, users)

        unless new_user.nil?
          users.push(new_user)
          user_index = users.length - 1
          selected_user = users[user_index].auth
        end
      elsif auth_menu_entry == "l"
        user_index = login_dialogue(users)
        if user_index.nil?
          print "\e[H\e[2J"
          puts "Sorry, that username does not exist in our database. Please try again."
          puts "Press any key to continue."
          STDIN.getch
        else
          print "Password: "
          selected_user = users[user_index].auth
        end
      elsif auth_menu_entry == "q"
        return users
      else
        puts "#{auth_menu_entry} is an invalid option, please try again."
        puts "Press any key to continue."
        STDIN.getch
      end
    end

    # Updates selected user with any changes made
    selected_user.menu
    selected_user = nil
  end
end

# Adds new user to array
def add_user(new_user_id, users)
  print "Please enter a username: "
  new_username = Readline.readline.strip

  user_index = users.find_index { |user| user.username == new_username }

  if new_username.strip.empty?
    puts "You cannot create a user with an empty username, please try again."
    puts "Press any key to continue."
    STDIN.getch
    return nil
  elsif !user_index.nil?
    puts "There is already an account with that name, please try again."
    puts "Press any key to continue."
    STDIN.getch
    return nil
  end

  print "Do you want to set a password? (y/n) or (m) to return to the main login screen: "
  password_wanted = Readline.readline.strip.downcase

  new_user = nil

  while new_user.nil?
    if password_wanted == "y"
      print "Enter password: "
      new_password = Readline.readline
      new_user = User.new(new_user_id, new_username, new_password)
      print "Please confirm your password: "
    elsif password_wanted == "n"
      new_user = User.new(new_user_id, new_username)
    elsif password_wanted == "m"
      return nil
    end

  end

  return new_user
end

# Requests user input for username & checks if that user exists within the array.
def login_dialogue(users)
  print "Username: "
  entered_username = Readline.readline.strip
  user_index = users.find_index { |user| user.username == entered_username }
  return user_index
end

# Initializes application
main_dialogue("storage.yml")

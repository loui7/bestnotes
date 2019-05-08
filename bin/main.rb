require_relative "../lib/classes/Category"
require_relative "../lib/classes/Note"
require_relative "../lib/classes/User"

require "yaml"
require "io/console"
require "prawn"

def main_dialogue(storage)
  storage_path = File.dirname(__FILE__) << "/../lib/#{storage}"

  # Loads stored users arary into memory else initialises empty array and creates a file for it to be stored in
  if File.exist?(storage_path)
    users = YAML.safe_load(File.read(storage_path), [User, Category, Note, Time])
  else
    users = []
    File.open(storage_path, "w+") { |file| file.write(users.to_yaml) }
  end

  # Updates the users array based on activity within the session.
  users = bestnotes_ui(users)

  File.open(storage_path, "r+") { |file| file.write(users.to_yaml) }
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
        print "Press (l) to login, (r) to register or (q) to quit.\n> "
        auth_menu_entry = gets.strip.downcase
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
          puts "Press any key to continue"
          STDIN.getch
        else
          print "Password: "
          selected_user = users[user_index].auth
        end
      elsif auth_menu_entry == "q"
        return users
      else
        puts "#{auth_menu_entry} is an invalid option, please try again."
        puts "Press any key to continue"
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
  new_username = gets.strip

  user_index = users.find_index { |user| user.username == new_username }

  if new_username.strip.empty?
    puts "You cannot create a user with an empty username, please try again."
    puts "Press any key to continue"
    STDIN.getch
    return nil
  elsif !user_index.nil?
    puts "There is already an account with that name, please try again."
    puts "Press any key to continue"
    STDIN.getch
    return nil
  end

  print "Do you want to set a password? (y/n) or (m) to return to the main login screen: "
  password_wanted = gets.strip.downcase

  new_user = nil

  while new_user.nil?
    if password_wanted == "y"
      print "Enter password: "
      new_password = gets.chomp
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
  entered_username = gets.strip
  user_index = users.find_index { |user| user.username == entered_username }
  return user_index
end

# Initializes application
main_dialogue("./storage.yml")

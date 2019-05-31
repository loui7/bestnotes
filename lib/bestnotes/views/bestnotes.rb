require_relative "../helpers/responsive_wrap_override"
require_relative "../helpers/view_misc.rb"

require "io/console"
require "readline"

class BestNotesView
  def welcome_message
    clear_screen
    puts "Welcome to BestNotes!"
  end

  def no_accounts_error
    puts "No accounts found!"
  end

  def invalid_input_error(input)
    puts "Sorry, '#{input}' is not a valid option! Please try again."
    puts "(Enter '?' to see options.)"
    puts "Press any key to continue."
    STDIN.getch
  end

  def desired_username
    return Readline.readline("Please enter a username: ").strip
  end

  def username_unavailable
    puts "That username is unavailable. Press (r) to try a different username or (m) to return to the main login screen."
    return Readline.readline.strip.downcase
  end

  def password_optional
    puts "Do you want to set a password? (y/n) or (m) to return to the main login screen."
    return Readline.readline("> ").strip.downcase
  end

  def desired_password
    return Readline.readline("Please enter a password: ").strip
  end

  def login_screen
    clear_screen
    puts "Press (l) to login, (r) to register or (q) to quit."
    return Readline.readline("> ").strip.downcase
  end

  def username
    return Readline.readline("Username: ").strip
  end

  def no_matching_username_error
    puts "That username does not match any accounts in our database. Press (r) to try again or (m) to return to the main login screen."
    return Readline.readline("> ").strip
  end

  def password
    return Readline.readline("Password: ").strip
  end

  def wrong_password_error
    puts "That was not the correct password. Press (r) to try again or (m) to return to the main login screen."
    return Readline.readline("> ").strip
  end

  def logged_in_welcome(username)
    clear_screen
    puts "You are logged in as #{username}"
  end

  def no_categories_found
    puts "No categories found! Please press (n) to add a new category or (m) to return to the login screen."
    return Readline.readline("> ").strip.downcase
  end

  def add_category
    return Readline.readline("Please enter a name for your new category: ").strip
  end

  def list_categories(categories)
    puts "Categories:"
    categories.each { |category| puts "#{category[0]}. #{category[1]}" }
    return Readline.readline("> ").strip.downcase
  end

  def invalid_id
    puts "That was not a valid ID! Please try again."
    puts "(Enter '?' to see options.)"
    puts "Press any key to continue."
    STDIN.getch
  end

  def category_menu_options
    clear_screen
    puts "----Options----"
    puts "Input the number next to a category you would like to select.\n(n) to add a new category\n(m) to return to the login screen."
    puts "Press any key to continue."
    STDIN.getch
  end

  def no_notes_found(category_name)
    puts "You do not currently have any notes in '#{category_name}'. Press (n) to add a new note or (m) to return to the previous menu."
    return Readline.readline("> ").strip.downcase
  end

  def add_note
    clear_screen
    puts "Enter new note:"
    return Readline.readline
  end

  def list_notes(category_name, notes)
    puts "Selected category: #{category_name}"
    puts "Notes:"
    notes.each { |note| puts "#{note[:id]}. #{note[:contents]}" }
    return Readline.readline("> ").strip.downcase
  end

  def note_menu_options
    clear_screen
    puts "----Options----"
    puts "Input the number next to a note you would like to select\n(n) to add a new note\n(d) to delete this category with all notes\n(p) to generate a pdf of all notes in this category.\n(m) to return to the previous menu."
    puts "Press any key to continue."
    STDIN.getch
  end

  def note_selected_menu(contents, creation_time)
    clear_screen
    puts "Selected note: #{contents}"
    puts "Date created: #{creation_time.strftime("%d/%m/%y")}"
    puts "Press (u) to update, (d) to delete or (m) to return to previous menu."
    return Readline.readline("> ").strip.downcase
  end

  def get_pdf_filename
    return Readline.readline("Filename: ").strip
  end

  def filename_exists_error
    puts "Sorry, you have already created a file with that name. Press (r) to try again or (m) to return to the previous menu."
    return Readline.readline("> ").strip.downcase
  end

  def invalid_filename
    puts "You have not entered a valid filename. Press (r) to try again or (m) to return to the previous menu."
    return Readline.readline("> ").strip.downcase
  end

  def pdf_export_success
    puts "Your PDF has been successfully generated!"
    puts "Press any key to continue."
    STDIN.getch
  end

  def update_note(existing_contents)
    puts "Please enter updated note:"
    # Prefills input with existing contents of note to be edited
    Readline.pre_input_hook = -> do
      Readline.insert_text existing_contents
      Readline.redisplay
      Readline.pre_input_hook = nil
    end
    return Readline.readline
  end

  def confirm_deletion
    puts "Are you sure you would like to delete this note? (y/n)"
    puts "WARNING: Once deleted, it will be impossible to recover."
    return Readline.readline("> ").strip.downcase
  end
end

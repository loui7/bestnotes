class User
  attr_reader :id, :username
  def initialize(id, username, password = nil)
    @id = id
    @username = username
    @password = password
    @categories = []
  end

  def auth
    return self if @password.nil?

    loop do
      entered_password = Readline.readline

      return self if entered_password == @password

      # returns to top of auth loop unless user enters 'm'
      print "That was not the correct password. Press (r) to try again or (m) to return to the main login screen."
      incorrect_password_prompt_response = Readline.readline.strip
      case incorrect_password_prompt_response
      when "r"
        print "Password: "
      when "m"
        return nil
      end
    end
  end

  def add_category
    print "Please enter a name for your new category: "
    new_category_id = @categories.length + 1
    new_category_name = Readline.readline.strip
    if new_category_name.strip.empty?
      puts "You cannot create a category with no name."
    else
      new_category = Category.new(new_category_id, new_category_name)
      @categories.push(new_category)
    end
  end

  def menu
    loop do
      print "\e[H\e[2J"
      puts "You are logged in as #{@username}"
      if @categories.empty?
        print "No categories found! Please press (n) to add a new category or (m) to return to the login screen.\n> "
      else
        puts "(Enter '?' to see more options.)"
        puts "Categories:"
        @categories.each { |category| puts "#{category.id}. #{category.name}" }
        print "> "
      end

      menu_entry = Readline.readline.strip.downcase

      if menu_entry.to_i != 0
        category_menu(menu_entry.to_i)
      elsif menu_entry == "n"
        add_category
      elsif menu_entry == "?"
        print "\e[H\e[2J"
        puts "----Options----"
        puts "- Input the number next to a category you would like to select.\n- (n) to add a new category\n- (m) to return to the login screen."
        puts "Press any key to continue"
        STDIN.getch
      elsif menu_entry == "m"
        return
      else
        puts "#{menu_entry} is an invalid option, please try again."
      end
    end
  end

  def category_menu(category_id)
    category_index = @categories.find_index { |category| category.id == category_id }

    if category_index.nil?
      puts "That was not a valid ID! Please try again."
      return
    end

    selected_category = @categories[category_index]

    # selected_note.menu returns true if the user indicated they wanted to delete the category.
    if selected_category.menu
      @categories.delete_at(category_index)
      puts "Category succesfully deleted."
    end
  end
end

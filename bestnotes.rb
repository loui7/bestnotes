require_relative "./classes/Category"
require_relative "./classes/Note"
require_relative "./classes/User"

users = []

puts "Hello, Welcome to BestNotes"

user_index = nil
selected_user = nil

loop do
    while selected_user.nil?
        if users.empty?
            puts "No accounts found!"
        else
            puts "Press (l) to login or (r) to register."
            auth_menu_entry = gets.strip.downcase
        end

        # If there are no users OR the user specifically wants to add an account. Creates new user account.
        if users.empty? || auth_menu_entry == "r"
            puts "Please enter a username: "
            new_username = gets.strip

            new_user_id = users.length + 1

            puts "Do you want to set a password? (y/n) or (m) to return to the main login screen."
            password_wanted = gets.strip.downcase

            new_user = nil

            while new_user.nil?
                if password_wanted == "y"
                    puts "Enter password: "
                    new_password = gets.chomp
                    new_user = User.new(new_user_id, new_username, new_password)
                elsif password_wanted == "n"
                    new_user = User.new(new_user_id, new_username)

                end

            end

            users.push(new_user)
            user_index = users.length - 1
            # TODO make user confirm password? Find way to avoid it being possible to access object without password.
            selected_user = users[user_index]
        elsif auth_menu_entry == "l"
            puts "Please enter your username: "
            entered_username = gets.strip
            user_index = users.find_index { |user| user.username == entered_username }
            if user_index.nil?
                puts "That username was not found! please try again"
            else
                selected_user = users[user_index].auth
            end
        else
            puts "#{auth_menu_entry} is an invalid option, please try again."
        end
    end

    until selected_user.nil?

        if selected_user.categories.empty?
            puts "No categories found! Please press (n) to add a new category or (m) to return to the login screen."
        else
            puts "These are your current categories:"
            selected_user.categories.each { |category| puts "#{category.id}. #{category.name}" }
            puts "Please input the number next to the category you would like to select. Otherwise, you can press (n) to add a new category or (m) to return to the login screen."
        end

        category_menu_entry = gets.strip.downcase

        if category_menu_entry.to_i != 0
            selected_user.category_menu(category_menu_entry.to_i)
        elsif category_menu_entry == "n"
            selected_user.add_category
        elsif category_menu_entry == "m"
            users[user_index] = selected_user
            user_index = nil
            selected_user = nil
        else
            puts "#{category_menu_entry} is an invalid option, please try again."
        end

    end
end

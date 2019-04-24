require_relative "./classes/Category"
require_relative "./classes/Note"
require_relative "./classes/User"

require "yaml"

def main_dialogue(storage)
    if File.exist?(storage)
        users = YAML.safe_load(File.read(storage), [User, Category, Note, Time])
    else
        users = []
        File.open(storage, "w+") { |file| file.write(users.to_yaml) }
    end

    puts "Hello, Welcome to BestNotes"

    users = users_dialogue(users)

    File.open(storage, "r+") do |f|
        f.write(users.to_yaml)
    end
end

def users_dialogue(users)
    selected_user = nil

    loop do
        while selected_user.nil?
            if users.empty?
                puts "No accounts found!"
            else
                puts "Press (l) to login, (r) to register or (q) to quit."
                auth_menu_entry = gets.strip.downcase
            end

            if users.empty? || auth_menu_entry == "r"
                new_user = add_user(users.length + 1)
                users.push(new_user)
                user_index = users.length - 1
                selected_user = users[user_index].auth
            elsif auth_menu_entry == "l"
                user_index = login_dialogue(users)
                if user_index.nil?
                    puts "Sorry, that username does not exist in our database. Please try again."
                else
                    selected_user = users[user_index].auth
                end
            elsif auth_menu_entry == "q"
                return users
            else
                puts "#{auth_menu_entry} is an invalid option, please try again."
            end
        end

        selected_user = categories_dialogue(selected_user)

        users[user_index] = selected_user
        selected_user = nil
    end
end

def add_user(new_user_id)
    puts "Please enter a username: "
    new_username = gets.strip

    puts "Do you want to set a password? (y/n) or (m) to return to the main login screen."
    password_wanted = gets.strip.downcase

    new_user = nil

    while new_user.nil?
        if password_wanted == "y"
            puts "Enter password: "
            new_password = gets.chomp
            new_user = User.new(new_user_id, new_username, new_password)
            puts "Please confirm your password."
        elsif password_wanted == "n"
            new_user = User.new(new_user_id, new_username)
        elsif password_wanted == "m"
            return nil
        end

    end

    return new_user
end

def login_dialogue(users)
    puts "Username: "
    entered_username = gets.strip
    user_index = users.find_index { |user| user.username == entered_username }
    if user_index.nil?
        puts "That username was not found! please try again"
        return nil
    else
        puts "Password: "
        return user_index
    end
end

def categories_dialogue(selected_user)
    loop do
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
            return selected_user
        else
            puts "#{category_menu_entry} is an invalid option, please try again."
        end
    end
end

main_dialogue("./storage.yml")

require_relative "./classes/Category"
require_relative "./classes/Note"
require_relative "./classes/User"

users = []

puts "Hello, Welcome to BestNotes"

selected_user = nil

loop do
    while selected_user.nil?
        if users.length.zero?
            puts "No accounts found!"
        else
            puts "Would you like to (l)ogin or (r)egister"
            auth_menu_entry = gets.strip.downcase
        end

        if auth_menu_entry == "r" || users.length.zero?
            puts "Please enter a username: "
            new_username = gets.strip
            new_user_id = users.length + 1
            new_user = User.new(new_user_id, new_username)
            users.push(new_user)
            user_index_if_exists = users.length - 1
            selected_user = users[user_index_if_exists]
        elsif auth_menu_entry == "l"
            puts "Please enter your username: "
            entered_username = gets.strip
            user_index_if_exists = users.find_index { |user| user.username == entered_username }
            if user_index_if_exists.nil?
                puts "That username was not found! please try again"
            else
                selected_user = users[user_index_if_exists]
            end
        else
            puts "#{auth_menu_entry} is an invalid option, please try again."
        end
    end

    unless selected_user.categories.empty?
        puts "These are your current categories:"
        selected_user.categories.each { |category| puts category.name }
    end

    puts "Please enter a category: "

    category_name = gets.strip

    category_index_if_exists = selected_user.categories.find_index { |category| category.name == category_name }

    if category_index_if_exists.nil?
        selected_category = selected_user.categories[category_index_if_exists]
    else
        new_category_id = selected_user.categories.length + 1
        selected_user.add_category(Category.new(new_category_id, category_name))
        selected_category = selected_user.categories[selected_user.categories.length - 1]
        category_index_if_exists = selected_user.categories.length - 1
    end

    puts "You have selected category #{selected_category.name}"

    until selected_category.nil?
        if selected_category.notes.empty?
            puts "You do not currently have any notes in this category. Press (n) to add a new note or (m) to return to the previous menu."
        else
            puts "These are your current notes: "
            selected_category.notes.each { |note| puts "#{note.id}. #{note.contents}" }
            puts "Please input the number next to the note you would like to select. You can also input (n) to add a new note or (m) to return to the previous menu."
        end

        notes_menu_entry = gets.strip

        if notes_menu_entry.to_i != 0
            selected_category.note_menu(notes_menu_entry.to_i)
        elsif notes_menu_entry == "n"
            selected_category.add_note
        elsif notes_menu_entry == "m"
            selected_user.update_category(category_index_if_exists, selected_category)
            selected_category = nil
        else
            puts "#{notes_menu_entry} is an invalid option, please try again."
        end

    end
end

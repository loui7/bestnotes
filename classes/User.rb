class User
    attr_reader :id, :username, :categories, :password
    def initialize(id, username, password = nil)
        @id = id
        @username = username
        @categories = []
        @password = password
    end

    def add_category
        puts "Please enter a name for your new category: "
        new_category_id = @categories.length + 1
        new_category_name = gets.strip
        new_category = Category.new(new_category_id, new_category_name)
        @categories.push(new_category)
    end

    def auth
        return self if @password.nil?

        loop do
            entered_password = gets.chomp

            return self if entered_password == password

            # returns to top of auth loop unless user enters 'm'
            puts "That was not the correct password. Press (r) to try again or (m) to return to the main login screen."
            incorrect_password_prompt_response = gets.strip
            case incorrect_password_prompt_response
            when "r"
                puts "Password: "
            when "m"
                return nil
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
        puts "You have selected the following Category: "
        puts selected_category.name

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
                categories[category_index] = selected_category
                selected_category = nil
            else
                puts "#{notes_menu_entry} is an invalid option, please try again."
            end
        end
    end
end

class User
    attr_reader :id, :username, :categories, :password
    def initialize(id, username, password = nil)
        @id = id
        @username = username
        @password = password
        @categories = []
    end

    def auth
        return self if @password.nil?

        puts "Password: "
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

    def add_category
        puts "Please enter a name for your new category: "
        new_category_id = @categories.length + 1
        new_category_name = gets.strip
        new_category = Category.new(new_category_id, new_category_name)
        @categories.push(new_category)
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

        selected_category.menu
    end
end

require_relative "./classes/Category"
require_relative "./classes/Note"

categories = []

puts "Hello, Welcome to BestNotes"

loop do

    
    if(categories.length > 0)
        puts "These are your current categories:"
        categories.each {|category| puts category.name}
    end

    puts "Please enter a category: "

    category_name = gets.strip

    category_index_if_exists = categories.find_index {|category| category.name == category_name}

    if(category_index_if_exists != nil)
        selected_category = categories[category_index_if_exists]
    else
        new_category_id = categories.length + 1
        categories.push(Category.new(new_category_id, category_name))
        selected_category = categories[categories.length - 1]
        category_index_if_exists = categories.length - 1
    end    

    puts "You have selected category #{selected_category.name}"

    until selected_category == nil
        if(selected_category.notes.length == 0)
            selected_category.add_note            
        end

        puts "These are your current notes: "
        selected_category.notes.each {|note| puts "#{note.id}. #{note.contents}" }

        puts "Please input the number next to the note you would like to select. You can also input (n) to add a new note or (m) to return to the previous menu."

        notes_menu_entry = gets.strip

        if(notes_menu_entry.to_i != 0)
            selected_category.note_menu(notes_menu_entry.to_i)
        elsif(notes_menu_entry == "n")
            selected_category.add_note
        elsif(notes_menu_entry == "m")
            categories[category_index_if_exists] = selected_category
            selected_category = nil
        else
            puts "#{notes_menu_entry} is an invalid option, please try again."
        end

    end
end


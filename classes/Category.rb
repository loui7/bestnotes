class Category
    attr_reader :id, :name, :notes

    def initialize(id, name)
            @id = id
            @name = name
            @notes = []
    end

    def add_note()
        puts "Enter note: "
        new_note_id = @notes.length + 1
        new_note_contents = gets.chomp
        new_note = Note.new(new_note_id, new_note_contents)
        @notes.push(new_note)
    end
    def note_menu(note_id)
        note_index_if_exists = @notes.find_index {|note| note.id == note_id}
        if(note_index_if_exists != nil)
            selected_note = @notes[note_index_if_exists]
            puts "You have selected the following note: "
            puts selected_note.contents
                until selected_note == nil
                puts "Press (e) to edit or (m) to return to previous menu."
                selected_note_menu_entry = gets.strip.downcase
                if (selected_note_menu_entry == "e")
                    puts "How would you like to edit your note?"
                    updated_note_contents = gets.chomp
                    selected_note.update_note(updated_note_contents)
                    puts "You have successfully edited your note."
                elsif (selected_note_menu_entry == "m")
                    @notes[note_index_if_exists] = selected_note
                    selected_note = nil
                else
                    puts "#{selected_note_menu_entry} is an invalid option, please try again."
                end
            end
        end
    end
end
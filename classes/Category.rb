class Category
    attr_reader :id, :name, :notes

    def initialize(id, name)
        @id = id
        @name = name
        @notes = []
    end

    def add_note
        puts "Enter note: "
        new_note_id = @notes.length + 1
        new_note_contents = gets.chomp
        new_note = Note.new(new_note_id, new_note_contents)
        @notes.push(new_note)
    end

    def menu
        loop do
            if @notes.empty?
                puts "You do not currently have any notes in this category. Press (n) to add a new note or (m) to return to the previous menu."
            else
                puts "These are your current notes: "
                @notes.each { |note| puts "#{note.id}. #{note.contents}" }
                puts "Please input the number next to the note you would like to select. You can also input (n) to add a new note or (m) to return to the previous menu."
            end

            notes_menu_entry = gets.strip

            if notes_menu_entry.to_i != 0
                note_menu(notes_menu_entry.to_i)
            elsif notes_menu_entry == "n"
                add_note
            elsif notes_menu_entry == "m"
                return
            else
                puts "#{notes_menu_entry} is an invalid option, please try again."
            end
        end
    end

    def note_menu(note_id)
        note_index = @notes.find_index { |note| note.id == note_id }

        if note_index.nil?
            puts "That was not a valid ID! Please try again."
            return
        end

        selected_note = @notes[note_index]
        puts "You have selected the following note: "
        puts selected_note.contents

        if selected_note.menu
            @notes.delete_at(note_index)
            puts "Note succesfully deleted."
        end
    end
end

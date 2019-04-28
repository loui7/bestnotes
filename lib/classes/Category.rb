class Category
    attr_reader :id, :name

    def initialize(id, name)
        @id = id
        @name = name
        @notes = []
    end

    def add_note
        puts "\e[H\e[2J"
        puts "Enter new note: "
        new_note_id = @notes.length + 1
        new_note_contents = gets.chomp
        if new_note_contents.strip.empty?
            puts "You cannot create empty notes."
        else
            new_note = Note.new(new_note_id, new_note_contents)
            @notes.push(new_note)
        end
    end

    def menu
        loop do
            puts "\e[H\e[2J"

            if @notes.empty?
                print "You do not currently have any notes in '#{@name}'. Press (n) to add a new note or (m) to return to the previous menu.\n> "
            else
                puts "(Enter '?' to see more options.)"
                puts "Selected category: #{@name}"
                puts "Notes: "
                @notes.each { |note| puts "#{note.id}. #{note.contents}" }
                print "> "
            end

            menu_entry = gets.strip

            if menu_entry.to_i != 0
                note_menu(menu_entry.to_i)
            elsif menu_entry == "n"
                add_note
            elsif menu_entry == "?"
                puts "\e[H\e[2J"
                puts "- Input the number next to a note you would like to select\n- (n) to add a new note\n- (d) to delete this category with all notes\n- (p) to generate a pdf of all notes in this category.\n- (m) to return to the previous menu."
                puts "Press any key to continue"
                STDIN.getch
            elsif menu_entry == "p"
                generate_pdf
            elsif menu_entry == "d"
                return true
            elsif menu_entry == "m"
                return false
            else
                puts "#{menu_entry} is an invalid option, please try again."
            end
        end
    end

    def generate_pdf
        loop do
            Dir.mkdir("./pdfs") unless Dir.exist?("./pdfs")

            print "Filename: "; filename = gets.strip

            filename << ".pdf" unless filename.end_with?(".pdf")

            file_path = "./pdfs/#{filename}"

            if File.exist?(file_path)
                puts "Sorry, you have already created a file with that name. Please try again."
            elsif filename.strip.empty?
                puts "You have not entered a valid filename. Please try again."
            else
                Prawn::Document.generate(file_path) do |pdf|
                    table_arr = [
                        ["Note ID", "Contents", "Creation Date"]
                    ]
                    @notes.each { |note| table_arr.push([note.id, note.contents, note.creation_time]) }
                    pdf.define_grid(:columns => 3, :rows => table_arr.length, :gutter => 1)
                    table_arr.each_with_index { |row, row_index|
                        row.each_with_index { |data, column_index|
                            p row_index
                            p column_index
                            pdf.grid([row_index, column_index], [row_index + 1, column_index + 1]).bounding_box do
                                pdf.text data.to_s
                            end
                        }
                    }
                end
                return
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

        # selected_note.menu returns true if the user indicated they wanted to delete the note.
        if selected_note.menu
            @notes.delete_at(note_index)
            puts "Note succesfully deleted."
        end
    end
end

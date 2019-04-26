class Note
    attr_reader :id, :contents, :creation_time

    def initialize(id, contents)
        @id = id
        @contents = contents
        @creation_time = Time.now
    end

    def menu
        loop do
            puts "Press (u) to update, (d) to delete or (m) to return to previous menu."
            selected_note_menu_entry = gets.strip.downcase
            if selected_note_menu_entry == "u"
                puts "Please enter updated note: "
                @contents = gets.chomp
                puts "You have successfully edited your note."
            elsif selected_note_menu_entry == "d"
                return false
            elsif selected_note_menu_entry == "m"
                return true
            else
                puts "#{selected_note_menu_entry} is an invalid option, please try again."
            end
        end
    end
end

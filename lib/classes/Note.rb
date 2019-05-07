class Note
  attr_reader :id, :contents, :creation_time

  def initialize(id, contents)
    @id = id
    @contents = contents
    @creation_time = Time.now
  end

  def menu
    loop do
      puts "\e[H\e[2J"
      puts "Selected note: #{@contents}"
      puts "Date created: #{@creation_time.strftime("%d/%m/%y")}"
      print "Press (u) to update, (d) to delete or (m) to return to previous menu.\n> "
      selected_note_menu_entry = gets.strip.downcase
      if selected_note_menu_entry == "u"
        puts "Please enter updated note:"
        updated_note = gets.chomp
        if updated_note.strip.empty?
          puts "You must enter something to update your note to.\nPress any key to continue."
          STDIN.getch
        else
          @contents = updated_note
          puts "\e[H\e[2J"
          puts "You have successfully edited your note."
        end
      elsif selected_note_menu_entry == "d"
        return true
      elsif selected_note_menu_entry == "m"
        return false
      else
        puts "#{selected_note_menu_entry} is an invalid option, please try again."
      end
    end
  end
end

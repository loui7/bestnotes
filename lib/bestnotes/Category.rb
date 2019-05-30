class Category
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
    @notes = []
  end

  def add_note
    print "\e[H\e[2J"
    puts "Enter new note:"
    new_note_id = @notes.length + 1
    new_note_contents = Readline.readline
    if new_note_contents.strip.empty?
      puts "You cannot create empty notes."
    else
      new_note = Note.new(new_note_id, new_note_contents)
      @notes.push(new_note)
    end
  end

  def menu
    loop do
      print "\e[H\e[2J"

      if @notes.empty?
        print "You do not currently have any notes in '#{@name}'. Press (n) to add a new note or (m) to return to the previous menu.\n"
      else
        puts "(Enter '?' to see more options.)"
        puts "Selected category: #{@name}"
        puts "Notes:"
        @notes.each { |note| puts "#{note.id}. #{note.contents}" }
      end

      menu_entry = Readline.readline("> ").strip

      if menu_entry.to_i != 0
        note_menu(menu_entry.to_i)
      elsif menu_entry == "n"
        add_note
      elsif menu_entry == "?"
        print "\e[H\e[2J"
        puts "----Options----"
        puts "Input the number next to a note you would like to select\n(n) to add a new note\n(d) to delete this category with all notes\n(p) to generate a pdf of all notes in this category.\n(m) to return to the previous menu."
        puts "Press any key to continue."
        STDIN.getch
      elsif menu_entry == "p"
        generate_pdf
      elsif menu_entry == "d"
        return true
      elsif menu_entry == "m"
        return false
      else
        puts "#{menu_entry} is an invalid option, please try again."
        puts "Press any key to continue."
        STDIN.getch
      end
    end
  end

  def generate_pdf
    loop do
      print "Filename: "; filename = Readline.readline.strip
      filename << ".pdf" unless filename.end_with?(".pdf")

      pdf_dir = File.dirname(__FILE__) << "/../../pdfs"
      Dir.mkdir(pdf_dir) unless Dir.exist?(pdf_dir)

      file_path = pdf_dir + "/#{filename}"

      if File.exist?(file_path)
        puts "Sorry, you have already created a file with that name. Please try again."
        puts "Press any key to continue."
        STDIN.getch
      elsif filename.strip.empty?
        puts "You have not entered a valid filename. Please try again."
        puts "Press any key to continue."
        STDIN.getch
      else
        Prawn::Document.generate(file_path) do |pdf|
          pdf.text "Category: #{@name}", style: :bold, size: 16, align: :center

          sel_date = nil
          @notes.each do |note|
            date_str = note.creation_time.strftime("%d/%m/%Y")
            if date_str != sel_date
              sel_date = date_str
              pdf.move_down 10
              pdf.text "Added on: " + sel_date, style: :bold, size: 14
              pdf.move_down 5
            end
            pdf.text note.id.to_s, style: :bold
            pdf.text note.contents
            pdf.move_down 5
          end
          pdf.text "Exported from BestNotes #{Time.now.strftime("%c")}.", valign: :bottom
        end
        puts "Your PDF has been successfully generated!"
        puts "Press any key to continue."
        STDIN.getch
        return
      end
    end
  end

  def note_menu(note_id)
    note_index = @notes.find_index { |note| note.id == note_id }

    if note_index.nil?
      puts "That was not a valid option! Please try again."
      puts "Press any key to continue."
      STDIN.getch
      return
    end

    selected_note = @notes[note_index]

    # selected_note.menu returns true if the user indicated they wanted to delete the note.
    if selected_note.menu
      @notes.delete_at(note_index)
      puts "Note successfully deleted."
      puts "Press any key to continue."
      STDIN.getch
    end
  end
end

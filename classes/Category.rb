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

end
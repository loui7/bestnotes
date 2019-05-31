class CategoryModel
  attr_accessor :id, :name
  def initialize(id, name)
    @id = id
    @name = name
    @notes = []
  end

  def notes_exist?
    return !@notes.empty?
  end

  def add_note(contents)
    id = @notes.length + 1
    @notes.push(NoteModel.new(id, contents))
  end

  def get_notes
    @notes.map { |note| { id: note.id, contents: note.contents, creation_time: note.creation_time } }
  end

  def select_note(id)
    return @notes.find { |note| note.id == id }
  end

  def delete_note(note)
    @notes.delete(note)
  end
end

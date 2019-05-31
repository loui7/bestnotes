class NoteModel
  attr_accessor :id
  def initialize(id, contents)
    @id = id
    @contents = contents
    @creation_time = Time.now
  end

  def update_note(new_contents)
    @contents = new_contents
  end

  def get_details
    return { id: @id, contents: @contents, creation_time: @creation_time }
  end
end

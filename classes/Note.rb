class Note
    attr_reader :id, :contents, :creation_time

    def initialize(id, contents)
        @id = id
        @contents = contents
        @creation_time = Time.now
    end

    def update_note(new_contents)
        @contents = new_contents.to_s
    end
end


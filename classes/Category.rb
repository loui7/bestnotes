class Category
    attr_reader :id, :name, :notes

    def initialize(id, name)
            @id = id
            @name = name
            @notes = []
    end

end
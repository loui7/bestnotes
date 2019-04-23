class User
    
    attr_reader :id, :username, :categories
    def initialize(id, username)
        @id = id
        @username = username
        @categories = []
    end

def add_category(category)
    @categories.push(category)
end

def update_category(category_index, category)
    @categories[category_index] = category
end

end

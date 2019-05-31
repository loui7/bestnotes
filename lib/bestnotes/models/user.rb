class UserModel
  attr_accessor :username
  def initialize(username, password)
    @username = username
    @password = password
    @categories = []
  end

  def has_password?
    return !@password.nil?
  end

  def authorize(password)
    if @password == password
      return self
    else
      return nil
    end
  end

  def no_categories_exist?
    return @categories.empty?
  end

  def add_category(name)
    id = @categories.length + 1
    @categories.push(CategoryModel.new(id, name))
    return @categories[-1]
  end

  def get_categories
    return @categories.map { |category| [category.id, category.name] }
  end

  def select_category(id)
    return @categories.find { |category| category.id == id }
  end

  def delete_category(category)
    @categories.delete(category)
  end
end

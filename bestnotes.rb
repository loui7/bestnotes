require_relative "./classes/Category"

categories = []

puts "Hello, Welcome to BestNotes"

loop do
    
    if(categories.length > 0)
        puts "These are your current categories:"
        categories.each {|category| puts category.name}
    end

    puts "Please enter a category: "

    category_name = gets.strip

    category_index_if_exists = categories.find_index {|category| category.name == category_name}
    if(category_index_if_exists != nil)
        selected_category = categories[category_index_if_exists]
    else
        categories.push(Category.new(categories.length + 1, category_name))
        selected_category = categories[categories.length - 1]
    end
    
    puts "You have selected category #{selected_category.name}"

    

end


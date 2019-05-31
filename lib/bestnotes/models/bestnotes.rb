require_relative "./category.rb"
require_relative "./note.rb"
require_relative "./user.rb"

require "yaml"

class BestNotesModel
  def initialize
    @storage_path = File.dirname(__FILE__) << "/../../../storage.yml"
    @users = load_users
    @authorized_user = nil
    @selected_category = nil
    @selected_note = nil
  end

  def load_users
    if File.exist?(@storage_path)
      return YAML.safe_load(File.read(@storage_path), [UserModel, CategoryModel, NoteModel, Time])
    else
      return []
    end
  end

  def save_users
    File.open(@storage_path, "w+") { |file| file.write(@users.to_yaml) }
  end

  def no_users_exist?
    return @users.empty?
  end

  def logged_in?
    return !@authorized_user.nil?
  end

  def user_exists?(username)
    return @users.any? { |user| user.username == username }
  end

  def has_password?(username)
    return @users.find { |user| user.username == username }.has_password?
  end

  def new_user(username, password)
    @authorized_user = UserModel.new(username, password)
    @users.push(@authorized_user)
  end

  def authorize(username, password)
    @authorized_user = @users.find { |user| user.username == username }.authorize(password)
    return @authorized_user.nil? ? false : true
  end

  def logout
    @authorized_user = nil
  end

  def authorized_user_username
    return @authorized_user.username
  end

  def no_categories_exist?
    return @authorized_user.no_categories_exist?
  end

  def add_category(name)
    @selected_category = @authorized_user.add_category(name)
  end

  def get_categories
    return @authorized_user.get_categories
  end

  def select_category(id)
    @selected_category = @authorized_user.select_category(id)
    return @selected_category.nil? ? false : true
  end

  def deselect_category
    @selected_category = nil
  end

  def category_selected?
    return !@selected_category.nil?
  end

  def delete_category
    @authorized_user.delete_category(@selected_category)
    @selected_category = nil
  end

  def notes_exist?
    return @selected_category.notes_exist?
  end

  def selected_category_name
    return @selected_category.name
  end

  def add_note(contents)
    @selected_category.add_note(contents)
  end

  def get_notes
    return @selected_category.get_notes
  end

  def select_note(id)
    @selected_note = @selected_category.select_note(id)
    return @selected_note.nil? ? false : true
  end

  def note_selected?
    return !@selected_note.nil?
  end

  def deselect_note
    @selected_note = nil
  end

  def selected_note_details
    return @selected_note.get_details
  end

  def update_note(new_contents)
    @selected_note.update_note(new_contents)
  end

  def delete_note
    @selected_category.delete_note(@selected_note)
    @selected_note = nil
  end
end

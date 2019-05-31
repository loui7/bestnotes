require_relative "../models/bestnotes"
require_relative "../views/bestnotes"
require_relative "../helpers/export_notes"

class BestNotesController
  def initialize
    @bestnotes_view = BestNotesView.new
    @bestnotes_model = BestNotesModel.new
  end

  def run
    @bestnotes_view.welcome_message
    if @bestnotes_model.no_users_exist?
      @bestnotes_view.no_accounts_error
      register
    end

    loop do
      if !@bestnotes_model.logged_in?
        prompt_response = @bestnotes_view.login_screen
        if prompt_response == "l"
          login
        elsif prompt_response == "r"
          register
        elsif prompt_response == "q"
          break
        else
          @bestnotes_view.invalid_input_error(prompt_response)
        end
      elsif @bestnotes_model.logged_in?
        if @bestnotes_model.note_selected?
          note_selected_menu 
        elsif @bestnotes_model.category_selected?
          notes_menu
        else
          categories_menu
        end
      end

    end

    @bestnotes_model.save_users
    
  end

  def login
    loop do
      username = @bestnotes_view.username
      if @bestnotes_model.user_exists?(username)
        loop do
          if @bestnotes_model.has_password?(username)
            password = @bestnotes_view.password
          else
            password = nil
          end

          authorized = @bestnotes_model.authorize(username, password)

          if authorized
            return
          else
            prompt_response = @bestnotes_view.wrong_password_error
            return if prompt_response == "m"
          end
        end
      else
        prompt_response = @bestnotes_view.no_matching_username_error
        return if prompt_response == "m"
      end
    end
  end

  def register
    loop do
      desired_username = @bestnotes_view.desired_username
      unless @bestnotes_model.user_exists?(desired_username)
        prompt_response = @bestnotes_view.password_optional
        return if prompt_response == "m"

        if prompt_response == "y"
          desired_password = @bestnotes_view.desired_password
        elsif prompt_response == "n"
          desired_password = nil
        elsif prompt_response == "m"
          return
        else
          invalid_input_error(prompt_response)
        end

        @bestnotes_model.new_user(desired_username, desired_password)
        return
      else
        prompt_response = @bestnotes_view.username_unavailable
        return if prompt_response == "m"
      end
    end
  end

  def categories_menu
    loop do
      p @bestnotes_model.authorized_user_username
      @bestnotes_view.logged_in_welcome(@bestnotes_model.authorized_user_username)
      if @bestnotes_model.no_categories_exist?
        prompt_response = @bestnotes_view.no_categories_found

        if prompt_response == "n"
          add_category
          return
        elsif prompt_response == "m"
          @bestnotes_model.logout
          return
        else
          @bestnotes_view.invalid_input_error(prompt_response)
        end
      else
        prompt_response = @bestnotes_view.list_categories(@bestnotes_model.get_categories)

        if prompt_response.to_i != 0
          category_exists = @bestnotes_model.select_category(prompt_response.to_i)
          @bestnotes_view.invalid_id unless category_exists
          return
        elsif prompt_response == "n"
          add_category
          return
        elsif prompt_response == "?"
          @bestnotes_view.category_menu_options
        elsif prompt_response == "m"
          @bestnotes_model.logout
          return
        else
          @bestnotes_view.invalid_input_error(prompt_response)
        end
      end
    end
  end

  def add_category
    category_name = @bestnotes_view.add_category
    @bestnotes_model.add_category(category_name)
  end

  def notes_menu
    loop do
      @bestnotes_view.logged_in_welcome(@bestnotes_model.authorized_user_username)
      if @bestnotes_model.notes_exist? == false
        prompt_response = @bestnotes_view.no_notes_found(@bestnotes_model.selected_category_name)

        if prompt_response == "n"
          add_note
        elsif prompt_response == "m"
          @bestnotes_model.deselect_category
          return
        else
          @bestnotes_view.invalid_input_error(prompt_response)
        end
        
      else
        prompt_response = @bestnotes_view.list_notes(@bestnotes_model.selected_category_name, @bestnotes_model.get_notes)

        if prompt_response.to_i != 0
          note_exists = @bestnotes_model.select_note(prompt_response.to_i)
          @bestnotes_view.invalid_note_id unless note_exists
          return
        elsif prompt_response == "n"
          add_note
        elsif prompt_response == "d"
          @bestnotes_model.delete_category
          return
        elsif prompt_response == "p"
          export_notes_pdf
        elsif prompt_response == "?"
          @bestnotes_view.note_menu_options
        elsif prompt_response == "m"
          @bestnotes_model.deselect_category
          return
        else
          @bestnotes_view.invalid_input_error(prompt_response)
        end
      end
    end
  end

  def add_note
    note_contents = @bestnotes_view.add_note
    @bestnotes_model.add_note(note_contents)
  end

  def note_selected_menu
    loop do
      prompt_response = @bestnotes_view.note_selected_menu(*@bestnotes_model.selected_note_details)

      if prompt_response == "u"
        new_contents = @bestnotes_view.update_note(@bestnotes_model.selected_note_details[0])
        @bestnotes_model.update_note(new_contents)
      elsif prompt_response == "d"
        prompt_response = @bestnotes_view.confirm_deletion
        if prompt_response == "y"
          @bestnotes_model.delete_note 
          return
        end
      elsif prompt_response == "m"
        @bestnotes_model.deselect_note
        return
      end
    end
  end

  def export_notes_pdf
    loop do
      filename = @bestnotes_view.get_pdf_filename
      filename << ".pdf" unless filename.end_with?(".pdf")

      pdf_dir = File.dirname(__FILE__) << "/../../../pdfs"
      Dir.mkdir(pdf_dir) unless Dir.exist?(pdf_dir)

      file_path = pdf_dir + "/#{filename}"
      if File.exist?(file_path)
        prompt_response = @bestnotes_view.filename_exists_error
        return if prompt_response == "m"
      elsif filename == ".pdf"
        prompt_response = @bestnotes_view.invalid_filename
        return if prompt_response == "m"
      else
        export_notes(file_path, @bestnotes_model.selected_category_name, @bestnotes_model.get_notes)
        @bestnotes_view.pdf_export_success
        return
      end
    end
  end

end
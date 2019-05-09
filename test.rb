require 'tty-screen'

def puts(str)
  screen_width = TTY::Screen.size[1]
  p screen_width
  words = str.split(/ /)

  line_arr = words.reduce([""]) { |lines, word|
    index = lines.length - 1
    prev_newline = lines[index].rindex("\n")
    if lines[index].length - (prev_newline.nil? ? 0 : prev_newline + 1) + word.length > screen_width
      lines.push(word)
    else
      lines[index] = lines[index] + " " + word
    end

    lines
  }
  new_text = ""
  line_arr.each do |line|
    new_text.concat(line, "\n")
  end
  super(new_text)
end

text = "----Options----
Input the number next to a note you would like to select
(n) to add a new note
(d) to delete this category with all notes
(p) to generate a pdf of all notes in this category.
(m) to return to the previous menu.
Press any key to continue."

puts text

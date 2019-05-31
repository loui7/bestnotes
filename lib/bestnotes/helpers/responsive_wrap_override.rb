# Overrides print & puts to ensure text shows up correctly in terminals of any size without cutting words in half on wrap

require "tty-screen"

def print(str, is_puts = false)
  screen_width = TTY::Screen.size[1]
  words = str.split(/ /)
  trail_space = str[/ +$/]
  words[words.length - 1] = words[words.length - 1] + trail_space unless trail_space.nil?

  line_arr = words.each_with_object([""]) { |word, lines|
    index = lines.length - 1
    prev_newline = lines[index].rindex("\n")
    if lines[index].length - (prev_newline.nil? ? 0 : prev_newline + 1) + word.length + 1 > screen_width
      lines.push(word)
    elsif lines[index].empty?
      lines[index] = word
    elsif lines[index].length == prev_newline
      lines[index] = lines[index] + word
    else
      lines[index] = lines[index] + " " + word
    end
  }
  # p line_arr
  new_str = ""
  all_but_last = line_arr.length == 1 ? nil : line_arr.slice(0..line_arr.length - 2)
  all_but_last&.each { |line| new_str.concat(line, "\n") }
  new_str.concat(line_arr[line_arr.length - 1])

  new_str.concat("\n") if is_puts

  super(new_str)
end

def puts(str)
  print(str, true)
end
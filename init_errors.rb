# Class
class InitErrors
  def call_error(code, var, line_counter)
    if code == 1
      puts "Line #{line_counter}: Variable #{var} is not initialized"
      exit(1)
    elsif code == 2
      puts "Line #{line_counter}: Operator #{var} applied to empty stack"
      exit(2)
    elsif code == 3
      puts "Line #{line_counter}: #{var} elements in stack after evaluation"
      exit(3)
    elsif code == 4
      puts "Line #{line_counter}: Unknown keyword #{var}"
      exit(4)
    end
  end

  def exit_five(line_counter)
    if line_counter == -1
      puts "File cannot be found and/or read!"
    else
      puts "Line #{line_counter}: Could not evaluate expression!"
    end
    exit(5)
  end
end

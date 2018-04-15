# Class
class InitErrors
  def call_error(code, var, line_counter)
    if code == 1
      print "Line #{line_counter}: Variable #{var} is not initialized"
      exit(1)
    elsif code == 2
      print "Line #{line_counter}: Operator #{var} applied to empty stack"
      exit(2)
    elsif code == 3
      print "Line #{line_counter}: #{var} elements in stack after evaluation"
      exit(3)
    end
  end

  def exit_five(line_counter)
    print "Line #{line_counter}: Could not evaluate expression"
    exit(5)
  end
end

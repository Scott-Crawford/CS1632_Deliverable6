# Class
class InitErrors
  def call_error(code, var)
    if code == 1
      print "Line #{@line_counter}: #{var} is not initialized"
      exit(1)
    elsif code == 2
      print "Line #{@line_counter}: Operator #{var} applied to empty stack"
      exit(2)
    elsif code == 3
      print "Line #{@line_counter}: #{var} elements in stack after evaluation"
      exit(3)
    end
  end

  def exit_five
    print "Line #{@line_counter} has an invalid variable."
    exit(5)
  end
end

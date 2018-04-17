require 'minitest/autorun'
require_relative 'init_errors'

class InitErrorsTest < Minitest::Test

  def setup
    @init = InitErrors.new
  end

  def test_code_two # Runs if exit isn't called from method, rip
  	code = 2
  	var = '-'
  	line = 3
  	assert_output("Line 3: Operator - applied to empty stack\n") {@init.call_error(code, var, line, false)}
  end

  def test_code_one
  	code = 1
  	var = '-'
  	line = 3
  	assert_output("Line 3: Variable - is not initialized\n") {@init.call_error(code, var, line, false)}
  end

  def test_code_three
  	code = 3
  	var = 3
  	line = 3
  	assert_output("Line 3: 3 elements in stack after evaluation\n") {@init.call_error(code, var, line, false)}
  end

  def test_code_five
  	line = 3
  	assert_output("Line 3: Could not evaluate expression!\n") {@init.exit_five(line, false)}
  end
end

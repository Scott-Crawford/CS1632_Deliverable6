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
  	assert_output("Line 3: Operator - applied to empty stack") {@init.call_error(code, var, line)}
  end

  def test_code_one
  	code = 1
  	var = '-'
  	line = 3
  	assert_output("") {@init.call_error(code, var, line)}
  end

  def test_code_three
  	code = 3
  	var = '-'
  	line = 3
  	assert_output("Line 3: 3 elements in stack after evaluation") {@init.call_error(code, var, line)}
  end

  def test_code_five
  	code = 5
  	var = '-'
  	line = 3
  	assert_output("Line 3: Operator - applied to empty stack") {@init.call_error(code, var, line)}
  end
end

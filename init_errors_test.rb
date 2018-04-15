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
end

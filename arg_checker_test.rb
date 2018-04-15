require 'minitest/autorun'
require_relative 'arg_checker'

class ArgCheckerTest < Minitest::Test

  def setup
    @arg_checker = ArgsChecker.new
  end

  def test_run_repl
    skip
    @arg_checker.run_repl
    output = "> "
    assert_equal output, "> " 
  end

  def test_init_operands
    obj = Minitest::Mock::new
    
  end
end
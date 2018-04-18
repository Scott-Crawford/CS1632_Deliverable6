require 'minitest/autorun'
require_relative 'arg_checker'

class ArgCheckerTest < Minitest::Test

  def setup
    @arg_checker = ArgsChecker.new
  end

    # This test checks if an existing file is read in by file_reader.
  def test_check_existent_file
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@arg_checker.read_file(file_args)}
  end

  # This test checks if a nonexistent file is rejected by file_reader.
  def test_check_nonexistent_file
    file_args = ["../CS1632_Deliverable6/File69.rpn"]
    assert @arg_checker.read_file(file_args), 'INV'
  end

  # This test checks if a file with the rpn extension is read in by file_reader.
  def test_check_correct_file_extension
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@arg_checker.check_array_arguments(file_args)}
  end
  
  # This test checks if a file without the rpn extension is rejected in by file_reader.
  def test_check_incorrect_file_extension
    file_args = ["../CS1632_Deliverable6/File1.gupta"]
    assert @arg_checker.check_array_arguments(file_args), 'INV'
  end

=begin
  def test_check_no_file_provided
  
    file_args = []
    assert_output("") {@arg_checker.check_args(file_args)}
  end
=end

  def test_multiple_correct_files_provided
    file_args = ["File1.rpn File2.rpn File3.rpn"]
    assert @arg_checker.read_file(file_args), 'INV'
  end

  def test_do_math_let_keyword
    val = @arg_checker.do_file_math(['LET'])
    assert_equal val, []
  end

  def test_do_math_print_keyword
    val = @arg_checker.do_file_math(['PRINT'])
    assert_equal val, []
  end

  def test_do_math_quit_keyword
    val = @arg_checker.do_file_math(['QUIT'])
    assert_equal val, []
  end

  def test_do_math_empty
    val = @arg_checker.do_file_math([])
    assert_equal val, []
  end

  def test_branches_valid_let
    input = "LET A 1"
    refute_equal @arg_checker.branches(input), 'INV'
  end

  def test_branches_invalid_let
    input = "LETS A 1"
    assert_nil @arg_checker.branches(input)
  end

  def test_define_variable_nil
    input = ["LET"]
    assert_output("Line 0: Could not evaluate expression \n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_question_mark
    input = ["LET", "?", "1"]
    assert_output("Line 0: Could not evaluate expression \n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_laboon
    input = ["LET", "laboon", "1"]
    assert_output("Line 0: Could not evaluate expression \n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_no_rpn
    input = ["LET", "a"]
    assert_output("Line 0: Could not evaluate expression \n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_no_operator_rpn
    input = ["LET", "a", "1", "1"]
    assert_output("Line 0: 2 elements in stack after evaluation\n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_empty_stack_rpn
    input = ["LET", "a", "1", "+"]
    assert_output("Line 0: Operator + applied to empty stack\n") {@arg_checker.define_variable(input)}
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_variable_valid
    input = ["LET", "A", "1", "1", "+"]
    assert_output("2\n") {@arg_checker.define_variable(input)}
    assert_equal 2, @arg_checker.map["A"]
  end
  
  def test_handle_more_true
    input = ["LET", "A", "1", "1", "+"]
    val = true
    assert_output("") {@arg_checker.handle_more(input, val)}
  end
  
  def test_handle_more_no_operator_rpn
    input = ["1", "1"]
    val = false
    assert_output("Line 0: 2 elements in stack after evaluation\n") {@arg_checker.handle_more(input, val)}
  end

  def test_handle_more_valid
    input = ["1", "1", "+"]
    val = false
    assert_output("2\n") {@arg_checker.handle_more(input, val)}
    assert_equal 2, @arg_checker.stack[0]
  end
  
  def test_do_math_middle_keyword
    input = ["1", "PRINT", "+"]
    val = 0
    assert_output("Line 0: Could not evaluate expression \n") {val = @arg_checker.do_math(input)}
    assert_equal [], val
  end
  
  def test_do_math_empty_stack
    input = ["1", "+"]
    val = 0
    assert_output("Line 0: Operator + applied to empty stack\n") {val = @arg_checker.do_math(input)}
    assert_equal [], val
  end
  
  def test_do_math_missing_operator
    input = ["1", "1", "1", "+"]
    assert_equal ["1", 2], @arg_checker.do_math(input)
  end
  
  def test_do_math_divide_by_zero
    input = ["1", "0", "/"]
    val = 0
    assert_output("Line 0: Could not evaluate expression \n") {val = @arg_checker.do_math(input)}
    assert_equal [], val
  end
  
  def test_do_math_unitialized_variable
    input = ["a", "1", "+"]
    val = 0
    assert_output("Line 0: Variable a is not initialized\n") {val = @arg_checker.do_math(input)}
    assert_equal [], val
  end
  
  def test_do_math_valid
    input = ["1", "1", "1", "1", "1", "-", "+", "*", "/"]
    assert_equal [1], @arg_checker.do_math(input)
  end
  
  def test_init_operands_one
    @arg_checker.stack = ["1"]
    opt = "+"
    val = 0
    assert_output("Line 0: Operator + applied to empty stack\n") {val = @arg_checker.init_operands(opt)}
    assert_equal [], val
  end
  
  def test_init_operands_two
    @arg_checker.stack = ["1", "1"]
    opt = "+"
    assert_equal [1, 1], @arg_checker.init_operands(opt)
  end
  
   def test_init_operands_three
   @arg_checker.stack = ["1", "2", "3"]
    opt = "+"
    assert_equal [3, 2], @arg_checker.init_operands(opt)
  end
  
  def test_execute_rpn_valid_one
    input = [["LET A 1", "LET B 2", "PRINT A B +"]]
    val = 0
    assert_output("3\n") {val = @arg_checker.execute_rpn(input)}
    assert_equal [], val
  end
  
  def test_execute_rpn_valid_two
    input = [["LET A 1", "LET B 2", "PRINT A B +"], ["PRINT -1 1 +"]]
    val = 0
    assert_output("3\n0\n") {val = @arg_checker.execute_rpn(input)}
    assert_equal [], val
  end
  
  def test_execute_rpn_unknown_keyword
    input = [["LET A 1", "APPLE", "PRINT A B +"], ["PRINT -1 1 +"]]
    val = 0
    assert_output("") {val = @arg_checker.execute_rpn(input)}
    assert_equal [4, "APPLE", 2], val
  end
  
  def test_execture_rpn_other_error
    input = [["LET A 1", "LET B 2", "PRINT A B +"], ["PRINT C"]]
    val = 0
    assert_output("3\n") {val = @arg_checker.execute_rpn(input)}
    assert_equal [1, "C", 4], val
  end
  
  def test_define_file_variable_nil
    input = ["LET"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [5, 0, 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_question_mark
    input = ["LET", "?", "1"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [5, 0, 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_laboon
    input = ["LET", "laboon", "1"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [5, 0, 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_no_rpn
    input = ["LET", "a"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [5, 0, 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_no_operator_rpn
    input = ["LET", "a", "1", "1"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [3, 2, 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_empty_stack_rpn
    input = ["LET", "a", "1", "+"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal 'INV', val
    assert_equal [2, "+", 0], @arg_checker.error_data
    assert_equal Hash.new, @arg_checker.map
  end
  
  def test_define_file_variable_valid
    input = ["LET", "A", "1", "1", "+"]
    val = 0
    assert_output("") {val = @arg_checker.define_file_variable(input)}
    assert_equal [], val
    assert_equal [], @arg_checker.error_data
    assert_equal 2, @arg_checker.map["A"]
  end
  
  def test_do_more_math_valid
    @arg_checker.map["A"] = 1
    input = "a"
    val=0
    assert_output("") {val = @arg_checker.do_more_math(input)}
    assert_equal [], @arg_checker.error_data
    assert_equal true, val
    assert_equal [1], @arg_checker.stack
  end
  
  def test_do_more_math_invalid
    input = "a"
    val=0
    assert_output("") {val = @arg_checker.do_more_math(input)}
    assert_equal [1, "a", 0], @arg_checker.error_data
    assert_equal false, val
    assert_equal [], @arg_checker.stack
  end
end
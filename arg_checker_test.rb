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

  # This test checks a combination of valid and invalid files.
  def test_multiple_correct_files_provided
    file_args = ["File1.rpn File2.rpn File3.rpn"]
    assert @arg_checker.read_file(file_args), 'INV'
  end

  # This test checks the LET keyword returns a valid array.
  def test_do_math_let_keyword
    val = @arg_checker.do_file_math(['LET'])
    assert_equal val, []
  end
  
  # This test checks the PRINT keyword returns a valid array.
  def test_do_math_print_keyword
    val = @arg_checker.do_file_math(['PRINT'])
    assert_equal val, []
  end

  # This test checks the QUIT keyword returns a valid array.
  def test_do_math_quit_keyword
    val = @arg_checker.do_file_math(['QUIT'])
    assert_equal val, []
  end

  # This test checks that an empty input array returns a valid array.
  def test_do_math_empty
    val = @arg_checker.do_file_math([])
    assert_equal val, []
  end

  # This test checks a valid variable declaration.
  def test_branches_valid_let
    input = "LET A 1"
    refute_equal @arg_checker.branches(input), 'INV'
  end

  # This test checks an invalid keyword during variable declaration.
  def test_branches_invalid_let
    input = "LETS A 1"
    assert_nil @arg_checker.branches(input)
  end

  # This test checks that nil is returned from an empty input array.
  def test_check_first_element_input_empty
    input = []
    assert_nil @arg_checker.check_first_element(input)
  end

  # This test checks that nil is returned from a valid LET.
  def test_check_first_element_let
    input = 'LET A 1'
    val = @arg_checker.check_first_element(input)
    assert_nil val
  end

  # This test checks that nil is returned from a valid PRINT.
  def test_check_first_element_print
    input = 'PRINT 1 1 +'
    val = @arg_checker.check_first_element(input)
    assert_nil val
  end

  # This test checks that an empty array is returned from a valid LET.
  def test_define_variable_valid
    input = ['LET', 'A', '1']
    val = @arg_checker.define_variable(input)
    assert_equal val, []
  end

  # This test checks that the correct error message is displayed for an empty declaration.
  def test_define_variable_invalid
    input = []
    assert_output("Line 0: Could not evaluate expression\n") {@arg_checker.define_variable(input)}
  end

  # This test checks that the correct error message is displayed for code 1.
  def test_call_error_code_one
    code = 1
    var = 'A'
    assert_output("Line 0: Variable A is not initialized\n") {@arg_checker.call_error(code, var)}
  end

  # This test checks that the correct error message is displayed for an empty declaration.
  def test_handle_input_quit
    input = 'QUIT'
    val = @arg_checker.handle_input(input)
    assert_equal val, 'QUIT'
  end

  # This test checks that the correct error message is displayed for an invalid variable.
  def test_handle_input_let_unkown_keyword
    input = 'LET CDD 27'
    assert_output("Line 1: Unknown keyword CDD\n") {@arg_checker.handle_input(input)}
  end

  # This test checks that addition is handled properly on an empty stack.
  def test_init_operands_add
    input = '+'
    assert_output("Line 0: Operator + applied to empty stack\n") {@arg_checker.init_operands(input)}
  end

  # This test checks that subtraction is handled properly on an empty stack.
  def test_handle_operators_subtract
    input = '-'
    assert_output("Line 0: Operator - applied to empty stack\n") {@arg_checker.handle_operators(input)}
  end

  # This test checks that division by zero is handled properly on an empty stack.
  def test_handle_operators_division_by_zero
    input = '/'
    assert_output("Line 0: Operator / applied to empty stack\n") {@arg_checker.handle_operators(input)}
  end

  # This test checks that an empty file returns nil.
  def test_parse_file_line_empty
    input = []
    assert_nil @arg_checker.parse_file_line(input)
  end

  # This test checks that QUITting from a file returns INV.
  def test_parse_file_line_quit
    input = ['QUIT']
    assert_equal @arg_checker.parse_file_line(input), 'INV'
  end

  # This test checks that PRINTing an uninitialized variable returns each element.
  def test_parse_file_line_invalid
    input = ['PRINT', '1', 'd', '+']
    val = @arg_checker.parse_file_line(input)
    assert_equal val, input
  end
end
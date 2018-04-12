require 'minitest/autorun'
require_relative 'arg_checker'

class ArgsCheckerTest < Minitest::Test

  def setup
    @args_checker = ArgsChecker::new
  end

  def test_check_existent_file
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@args_checker.read_file(file_args)}
  end

  def test_check_nonexistent_file
    file_args = ["../CS1632_Deliverable6/File69.rpn"]
    assert_output("File does not exist with given path.\n") {@args_checker.read_file(file_args)}
  end

  def test_check_correct_file_extension
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@args_checker.check_array_arguments(file_args)}
  end
  
  def test_check_incorrect_file_extension
    file_args = ["../CS1632_Deliverable6/File1.gupta"]
    assert_output("Supplied file does not have the .rpn extension!\n") {@args_checker.check_array_arguments(file_args)}
  end

=begin
  def test_check_no_file_provided
  
    file_args = []
    assert_output("") {@args_checker.check_args(file_args)}
  end
=end

  def test_multiple_correct_files_provided
    file_args = ["File1.rpn File2.rpn File3.rpn"]
    assert_output("File does not exist with given path.\n") {@args_checker.read_file(file_args)}
  end
end
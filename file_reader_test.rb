require 'minitest/autorun'
require_relative 'file_reader'

class FileReaderTest < Minitest::Test

  def setup
    @file_reader = FileReader.new
  end

  # This test checks if an existing file is read in by file_reader.
  def test_check_existent_file
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@file_reader.read_file(file_args)}
  end

  # This test checks if a nonexistent file is rejected by file_reader.
  def test_check_nonexistent_file
    file_args = ["../CS1632_Deliverable6/File69.rpn"]
    assert @file_reader.read_file(file_args), 'INV'
  end

  # This test checks if a file with the rpn extension is read in by file_reader.
  def test_check_correct_file_extension
    file_args = ["../CS1632_Deliverable6/File1.rpn"]
    assert_output("") {@file_reader.check_array_arguments(file_args)}
  end
  
  # This test checks if a file without the rpn extension is rejected in by file_reader.
  def test_check_incorrect_file_extension
    file_args = ["../CS1632_Deliverable6/File1.gupta"]
    assert @file_reader.check_array_arguments(file_args), 'INV'
  end

=begin
  def test_check_no_file_provided
  
    file_args = []
    assert_output("") {@file_reader.check_args(file_args)}
  end
=end

  def test_multiple_correct_files_provided
    file_args = ["File1.rpn File2.rpn File3.rpn"]
    assert @file_reader.read_file(file_args), 'INV'
  end

  def test_do_math_let_keyword
    val = @file_reader.do_math(['LET'])
    assert_equal val, []
  end

  def test_do_math_print_keyword
    val = @file_reader.do_math(['PRINT'])
    assert_equal val, []
  end

  def test_do_math_quit_keyword
    val = @file_reader.do_math(['QUIT'])
    assert_equal val, []
  end

  def test_do_math_empty
    val = @file_reader.do_math([])
    assert_nil val
  end

  def test_branches_valid_let
    input = "LET A 1"
    refute_equal @file_reader.branches(input), 'INV'
  end

  def test_branches_invalid_let
    input = "LETS A 1"
    assert_nil @file_reader.branches(input)
  end


 
end
# Class that checks the file argument provided by user.
class ArgsChecker
  def check_args(arr)
    if arr.count < 1
      0
    else
      check_array_arguments(arr)
      read_file(arr)
    end
  end

  def read_file(arr)
    all_files = curr = []
    arr.each do |file_name|
      if File.file?(file_name)
        curr = File.readlines(file_name)
        all_files.push(curr)
      else
        puts 'File does not exist with given path.'
      end
    end
    all_files
  end

  def check_array_arguments(input)
    input.each do |file|
      if file.split('.')[1] != 'rpn'
        puts 'Supplied file does not have the .rpn extension!'
        abort
      end
    end
  end
  def handle_input(input)
    eval(input)
  end
  def run_repl
    repl = lambda { |prompt|
      print prompt
      handle_input(gets.chomp!)
    }
    loop do
      repl['> ']
    end
  end
end

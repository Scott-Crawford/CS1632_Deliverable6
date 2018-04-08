# Class that checks the file argument provided by user.
class ArgsChecker
  def check_args(arr)
    if arr.count < 1
      run_repl
    else
      all_files = Dir.glob('*')
      check_array_arguments(arr, all_files)
    end
  end

  def check_array_arguments(input, all_files)
    input.each do |file|
      if file.split('.')[1] != 'rpn'
        puts 'Supplied file does not have the .rpn extension!'
        abort
      end
    end
    unless (all_files & input).length == input.length
      puts 'File does not exist. Please try again!'
      abort
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

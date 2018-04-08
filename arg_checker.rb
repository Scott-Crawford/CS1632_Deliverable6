# Class that checks the file argument provided by user.
class ArgsChecker
  @stack = []
  def check_args(arr)
    if arr.count < 1
      run_repl
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
    @stack = []
    input = input.split(' ')
    input.each do |i|
      if %w[+ - * /].include? i
        handle_operators i
      else
        @stack.push i
      end
    end
    puts @stack
  end

  def handle_operators(opt)
    a = @stack.pop.to_i
    b = @stack.pop.to_i
    c = 0
    if opt == '+'
      c = a + b
    elsif opt == '-'
      c = b - a
    elsif opt == '*'
      c = a * b
    elsif opt == '/'
      c = b / a
    end
    @stack.push c
  end

  def run_repl
    @stack = [] if @stack.nil?
    repl = lambda { |prompt|
      print prompt
      handle_input(gets.chomp!)
    }
    loop do
      repl['> ']
    end
  end
end

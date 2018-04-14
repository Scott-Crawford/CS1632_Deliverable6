require_relative 'init_errors'
# Methods for reading in rpn files.
class FileReader
  @stack = []
  @line_counter = 0
  @map = {}
  @ie = InitErrors.new

  def init_values
    @map = {}
    @line_counter = 0
    all_files = curr = []
    vals = [all_files, curr]
    vals
  end

  def read_file(arr)
    vals = init_values
    arr.each do |file_name|
      if File.file?(file_name)
        vals[1] = File.readlines(file_name)
        vals[1].each(&:chomp!)
        vals[0].push(vals[1])
      else
        puts 'File does not exist with given path.'
      end
    end; vals[0]
  end

  def check_value(value)
    exit! if value == 'INVALID'
  end

  def check_array_arguments(input)
    input.each do |file|
      if (file[-3..-1] || file).strip != 'rpn'
        puts 'Supplied file does not have the .rpn extension!'
        return 'INVALID'
      end
    end
  end

  def execute_rpn(file)
    file.each do |line|
      line.each do |inner|
        @line_counter += 1
        inner = inner.split(' ')
        check_first_file_element(inner)
      end
    end
  end

  def quit_branch(input)
    exit! if input[0] == 'QUIT'
  end

  def branches(input)
    quit_branch(input)
    define_variable(input) if input[0] == 'LET'
  end

  def check_first_file_element(first_element)
    @stack = []
    if first_element[0] =~ /LET|PRINT|QUIT/
      branches(first_element)
      if first_element[0] == 'PRINT'
        do_math(first_element[1..first_element.length - 1])
        @ie.call_error(3, @stack.length) if @stack.length > 1
        puts @stack[0]
      end
      true
    end
  end

  def define_variable(input)
    ie = InitErrors.new
    # call_error(5, input[1]) if input[1].length != 1
    @map = {} if @map.nil?
    val = do_math(input[2..input.length - 1])
    ie.call_error(3, @stack.length) if @stack.length > 1
    @map[input[1].upcase] = val[0] unless val.empty?
    @stack.clear
  end

  def do_more_math(input)
    ie = InitErrors.new
    if @map.key?(input.upcase)
      @stack.push(@map[input.upcase])
    else
      ie.call_error(1, input)
      []
    end
  end

  def do_math(input)
    input.each do |i|
      if %w[+ - * /].include?(i)
        return [] unless handle_operators(i)
      elsif i.length == 1 && i.match(/[a-zA-Z]/)
        do_more_math(i)
      else
        @stack.push(i)
      end
    end
    @stack
  end

  def handle_operators(opt)
    operands = init_operands(opt)
    if operands.empty?
      false
    else
      operands[2] = operands[1].send opt, operands[0]
      @stack.push(operands[2])
      true
    end
  end

  def init_operands(opt)
    ie = InitErrors.new
    if @stack.length < 2
      ie.call_error(2, opt)
      []
    else
      a = @stack.pop.to_i
      b = @stack.pop.to_i
      c = 0
      [a, b, c]
    end
  end
end

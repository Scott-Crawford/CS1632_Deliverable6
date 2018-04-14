# Methods for reading in rpn files.
class FileReader
  @stack = []
  @line_counter = 0
  @map = {}

  def read_file(arr)
    @map = {}
    @line_counter = 0
    all_files = curr = []
    arr.each do |file_name|
      if File.file?(file_name)
        curr = File.readlines(file_name)
        curr.each(&:chomp!)
        all_files.push(curr)
      else
        puts 'File does not exist with given path.'
      end
    end
    all_files
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
        @line_counter+=1
        check_first_file_element(inner)
      end
    end
  end

  def check_first_file_element(input)
    @stack = []
    first_element = input.split(' ')
    if %w[LET PRINT QUIT].include?(first_element[0])
      if first_element[0] == 'QUIT'
        exit!
      elsif first_element[0] == 'LET'
        define_variable(first_element)
      elsif first_element[0] == 'PRINT'
        do_math(first_element[1..first_element.length - 1])
        call_error(3, @stack.length) if @stack.length > 1
        puts @stack[0]
      end
      true
    end
  end

  def define_variable(input)
    @map = {} if @map.nil?
    val = do_math(input[2..input.length - 1])
    call_error(3, @stack.length) if @stack.length > 1
    @map[input[1].upcase] = val[0] unless val.empty?
    @stack.clear
  end

  def call_error(code, var)
    if  code == 1
      print "Line #{@line_counter}: #{var} is not initialized"
      exit(1)
    elsif code == 2
      print "Line #{@line_counter}: Operator #{var} applied to empty stack" 
      exit(2)
    elsif code == 3
      print "Line #{@line_counter}: #{var} elements in stack after evaluation"
      exit(3)
    else
      exit(5)
    end
  end

  def do_math(input)
    input.each do |i|
      if %w[+ - * /].include?(i)
        return [] unless handle_operators(i)
      elsif i.length == 1 && i.match(/[a-zA-Z]/)
        if @map.key?(i.upcase)
          @stack.push(@map[i.upcase])
        else
          call_error(1, i)
          return []
        end
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
    if @stack.length < 2
      call_error(2, opt)
      []
    else
      a = @stack.pop.to_i
      b = @stack.pop.to_i
      c = 0
      [a, b, c]
    end
  end
end

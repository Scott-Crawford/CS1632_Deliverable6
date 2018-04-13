# Methods for reading in rpn files.
class FileReader
  @stack = []
  @line_counter = 0
  @map = {}

  def read_file(arr)
    all_files = curr = []
    arr.each do |file_name|
      if File.file?(file_name)
        curr = File.readlines(file_name)
        curr.each do |element|
          element.chomp!
        end
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
      check_first_file_element(line)
    end
  end

  def check_first_file_element(input)
    first_element = input[0].split(' ')[0].strip
    if %w[LET PRINT QUIT].include?(first_element)
      if first_element == 'QUIT'
        exit!
      elsif first_element == 'LET'
        define_variable(input[0])
      else
        do_math(input[1..input.length - 1])
      end
      true
    end
  end

  def define_variable(input)
    @map = {} if @map.nil?
    items = input[2..input.length - 1]
    val = do_math(items)
    @map[input[1].upcase] = val[0] unless val.empty?
    puts @map[input[1].upcase] unless val.empty?
    @stack.clear
  end

  def call_error(code, var)
    puts "Line BLAH: #{var} is not initialized" if code == 1
    @stack.clear
  end

  def handle_more(input, val)
    if input.length == 1 && input[0].length == 1 && input[0].match(/[a-zA-Z]/) && @map.key?(input[0].upcase)
      puts @map[input[0].upcase]
    else
      do_math(input) unless val
      puts @stack[0] unless @stack.empty? || @stack[0].nil?
    end
  end

  def handle_input(input)
    @stack = []
    input = input.split(' ')
    val = check_first_element(input)
    handle_more(input, val)
  end

  def do_math(input)
    input.each do |i|
      if %w[+ - * /].include?(i)
        handle_operators(i)
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
    operands = init_operands
    operands[2] = operands[1].send opt, operands[0]
    @stack.push(operands[2])
  end

  def init_operands
    a = @stack.pop.to_i
    b = @stack.pop.to_i
    c = 0
    [a, b, c]
  end
end

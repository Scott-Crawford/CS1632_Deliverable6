# Methods for reading in rpn files.
class FileReader
  @stack = []
  @line_counter = 0
  @map = {}
  @error_data = []

  def init_values
    @map = {}
    @line_counter = 0
    @error_data = []
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
        return 'INV'
      end
    end; vals[0]
  end

  def check_array_arguments(input)
    @error_data = []
    input.each do |file|
      return @error_data = [5, 0, -1] if (file[-3..-1] || file).strip != 'rpn'
    end
  end

  def parse_line(input)
    return if input[0].nil?
    @error_data = [0, 0, 0] if input[0].casecmp('QUIT').zero?
    return 'INV' if input[0].casecmp('QUIT').zero?
    input.each do |element|
      a = element.length == 1 && element.match(/[A-Za-z]/)
      b = %w[+ - / * LET PRINT QUIT].include?(element.upcase)
      c = element.to_i.to_s == element
      @error_data = [4, element, @line_counter] unless a || b || c
      return 'INV' unless a || b || c
    end
  end

  def execute_rpn(file)
    file.each do |line|
      line.each do |inner|
        @stack = []
        @line_counter += 1
        inner = inner.split(' ')
        return @error_data if parse_line(inner).eql? 'INV'
        check_first_file_element(inner)
        return @error_data unless @error_data.empty?
      end
    end; []
  end

  def branches(input)
    val = define_variable(input) if input[0].casecmp('LET').zero?
    return 'INV' if val == 'INV'
  end

  def check_first_file_element(first_el)
    return if first_el[0].nil?
    if first_el[0].upcase =~ /LET|PRINT|QUIT/
      val = branches(first_el)
      return 'INV' if val == 'INV'
      if first_el[0].casecmp('PRINT').zero?
        return 'INV' if do_math(first_el[1..first_el.length - 1]) == []
        @error_data = [3, @stack.length, @line_counter] if @stack.length > 1
        return 'INV' if @stack.length > 1
        puts @stack[0]
      end
    else
      do_math(first_el)
      @error_data = [3, @stack.length, @line_counter] if @stack.length > 1
      return 'INV' if @stack.length > 1
    end
  end

  def define_variable(inp)
    c = !inp[1].nil? && inp[1].length == 1 && inp[1].match(/[a-zA-Z]/)
    @error_data = [5, 0, @line_counter] unless c && inp.length > 2
    return 'INV' unless c && inp[1].match(/[a-zA-Z]/) || c
    @map = {} if @map.nil?
    val = do_math(inp[2..inp.length - 1])
    @error_data = [3, @stack.length, @line_counter] if @stack.length > 1
    return 'INV' if @stack.length > 1
    @map[inp[1].upcase] = val[0] unless val.empty?
    return 'INV' if val.empty?
    @stack.clear
  end

  def do_more_math(input)
    if @map.key?(input.upcase)
      @stack.push(@map[input.upcase])
      true
    else
      @error_data = [1, input, @line_counter]
      false
    end
  end

  def do_math(input)
    input.each do |i|
      if %w[LET PRINT QUIT].include?(i.upcase)
        @error_data = [5, 0, @line_counter]
        return []
      elsif %w[+ - * /].include?(i)
        return [] unless handle_operators(i)
      elsif i.length == 1 && i.match(/[a-zA-Z]/)
        return [] unless do_more_math(i)
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
    elsif operands[0].zero? && opt == '/'
      @error_data = [5, 0, @line_counter]
      false
    else
      @stack.push(operands[1].send(opt, operands[0]))
      true
    end
  end

  def init_operands(opt)
    if @stack.length < 2
      @error_data = [2, opt, @line_counter]
      []
    else
      a = @stack.pop.to_i
      b = @stack.pop.to_i
      [a, b]
    end
  end
end

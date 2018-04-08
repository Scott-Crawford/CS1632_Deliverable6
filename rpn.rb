require_relative 'arg_checker'
ac = ArgsChecker.new
ac.check_args(ARGV)

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
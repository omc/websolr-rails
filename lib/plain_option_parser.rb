class PlainOptionParser
  attr_reader :flags
  
  def initialize(&block)
    @commands = []
    desc "Prints help text for your command"
    cmd "help" do
      viable, remaining = commands_for_args(args[1, args.length])
      if viable.length == 0
        no_match
      else
        pretty_print viable
      end
    end
    instance_eval(&block)
  end

  def start(args)
    viable, remaining = commands_for_args(args)
    if viable.length == 1
      viable[0].last.call(*remaining)
    elsif viable.length == 0
      no_match
    else
      usage
      pretty_print viable
    end
  end
  
  def desc(string)
    @desc = string
  end
    
  def cmd(name, additional = "", &block)
    @commands << [name.split(/\s+/), @desc, additional, block]
    @desc = nil
  end
  
  def pretty_print(cmds)
    mapped = cmds.map do |cmd|
      name, desc, additional, block = cmd
      ["  #{File.basename($0)} " + name.join(" ") + " #{additional}", " -- #{desc}"]
    end
    max = mapped.inject(0) do |memo, entry|
      memo > entry.first.length ? memo : entry.first.length
    end
    mapped.each do |entry|
      puts entry.first + (" " * (max - entry.first.length)) + entry.last
    end
  end
  
private
  
  def usage
    puts "COMMANDS: "
  end
  
  
  KV_FLAG = /--(.*)=(.*)/
  K_FLAG  =  /--(.*)/
  def strip_flags(args)
    @flags ||= {}
    @prev = nil
    args.map do |arg|
      if arg =~ KV_FLAG
        @flags[$1] = $2
        nil
      elsif @prev            
        @flags[@prev] = arg
        @prev = nil
      elsif @prev = arg[K_FLAG, 1]
        nil
      else
        arg
      end
    end.compact
  end
  
  def commands_for_args(args)
    args = strip_flags(args)
    viable = @commands.dup
    args.each_with_index do |arg, i|
      @commands.each do |cmd|
        name, desc, additional, block = cmd
        viable.delete(cmd) if name[i] != arg
      end
      if viable.length == 1
        return [viable, args[viable[0][0].length, args.length]]
      end
    end
    return [viable, []]
  end
  
  def no_match
    puts "No matching command found."
    puts 
    usage
    pretty_print @commands
  end
end
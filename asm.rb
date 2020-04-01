#!/usr/bin/ruby


$debug = false
def debug(str)
  puts str if $debug
end

def out(str)
  debug "out #{str}"
  print str.gsub("s", " ").gsub("t", "\t").gsub("n", "\n")
end

def out_number(n)
  # * number requires terminal \n
  # * first character indicates sign where s is + and t is -
  debug "outnumber #{n} as #{sprintf("%02x", n)}"
  if n < 0
    print sprintf("\t%08b\n", n.abs()).gsub("0", " ").gsub("1", "\t")
  else
    print sprintf(" %08b\n", n.abs()).gsub("0", " ").gsub("1", "\t")
  end
end


def lex(input)
  input.gsub(/#.*$/, "").split
end

def parse(tokens)
  tokens.reverse!
  while !tokens.empty?
    case token = tokens.pop
    when "Stack"
      debug "stack"
      out "s"
      case token = tokens.pop
      when "push"
        debug "push"
        out "s"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg

      when "dup"
        debug "dup"
        out "ns"
      when "discard"
        debug "discard"
        out "nn"
      when "copy"
        debug "copy nth item"
        out "ts"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg

      when "swap"
        debug "swap"
        out "nt"
      when "slide"
        debug "slide n items off"
        out "tn"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg
      else
        puts "unknown Stack inst #{token}"
      end
    when "Arith"
      debug "arith"
      out "ts"

      case token = tokens.pop
      when "add"
        debug "add"
        out "ss"
      when "sub"
        debug "sub"
        out "st"
      when "mul"
        debug "mul"
        out "sn"
      when "div"
        debug "div"
        out "ts"
      when "mod"
        debug "mod"
        out "tt"
      else
        puts "unknown Arith inst #{token}"
      end
    when "Heap"
      debug "heap"
      out "tt"

      case token = tokens.pop
      when "store"
        debug "store"
        out "s"
      when "retrieve"
        debug "retrieve"
        out "t"
      else
        puts "unknown Heap inst #{token}"
      end
    when "Flow"
      debug "flow"
      out "n"

      case token = tokens.pop
      when "label"
        debug "mark location"
        out "ss"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg
      when "jump"
        debug "jump to label"
        out "sn"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg

      when "jz"
        debug "jump if zero"
        out "ts"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg
      when "jneg"
        debug "jump if neg"
        out "tt"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg
      when "call"
        debug "call subroutine"
        out "st"

        arg = parse_number(tokens.pop)
        debug arg
        out_number arg
      when "return"
        debug "return"
        out "tn"
      when "end"
        debug "exit"
        out "nn"
      else
        puts "unknown Flow inst #{token}"
      end
    when "IO"
      debug "io"
      out "tn"

      case token = tokens.pop
      when "outchar"
        debug "outchar"
        out "ss"
      when "readchar"
        debug "readchar"
        out "ts"
      when "outnumber"
        debug "outnumber"
        out "st"
      when "readnumber"
        debug "readnumber"
        out "tt"
      else
        puts "unknown IO inst #{token}"
      end
    else
      puts "unknown Inst type #{token}"
    end
  end
end

def parse_number(arg)
  if arg =~ /'(.)'/
    $1.ord
  elsif arg =~ /'\\(.)'/
    case $1
    when "n"
      "\n".ord
    when "t"
      "\t".ord
    end
  elsif arg =~ /0x([0-9a-f]{1,})/
    $1.to_i(16)
  else
    arg.to_i
  end
end
input ||= open(ARGV[0],"r").read()

parse(lex(input))

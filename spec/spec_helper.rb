require 'date'

def Date.call(arg)
  return arg.to_date if arg.respond_to?(:to_date)
  parse(arg)
end

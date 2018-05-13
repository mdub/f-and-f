module Familial
  module Chiller

    def chill(arg)
      return arg if arg.frozen?
      arg.dup.freeze
    end

    module_function :chill

  end
end

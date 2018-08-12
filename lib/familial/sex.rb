require "another_enum"

module Familial

  class Sex < AnotherEnum

    define :male
    define :female

    def to_gedcom
      code[0].upcase
    end

  end

end

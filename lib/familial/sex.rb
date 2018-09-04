require "another_enum"

module Familial

  class Sex < AnotherEnum

    define :male do
      hardcode symbol: "♂"
    end

    define :female do
      hardcode symbol: "♀"
    end

    def to_gedcom
      code[0].upcase
    end

  end

end

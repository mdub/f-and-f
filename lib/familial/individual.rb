require "familial/date"
require "familial/record"

module Familial

  class Individual < Record

    attr_accessor :name

    attr_reader :birth_date

    def birth_date=(arg)
      @birth_date = Date.parse(arg)
    end

  end

end

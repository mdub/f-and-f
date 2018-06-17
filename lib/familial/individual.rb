require "familial/date"
require "familial/record"

module Familial

  class Individual < Record

    attr_accessor :name

    attr_reader :birth

    def birth=(arg)
      @birth = Date.parse(arg)
    end

  end

end

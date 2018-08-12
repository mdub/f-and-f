require "familial/date"
require "familial/record"

module Familial

  class Family < Record

    attr_reader :date_married

    def date_married=(arg)
      @date_married = Date.parse(arg)
    end

  end

end

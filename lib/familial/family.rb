require "familial/date"
require "familial/record"

module Familial

  class Family < Record

    def date_married=(arg)
      @date_married = Date.parse(arg)
    end

    attr_reader :date_married

    attr_accessor :husband
    attr_accessor :wife

    def children
      @children ||= []
    end

  end

end

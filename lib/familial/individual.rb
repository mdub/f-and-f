require "familial/date"
require "familial/record"

module Familial

  class Individual < Record

    attr_accessor :name

    attr_reader :date_of_birth

    def date_of_birth=(arg)
      @date_of_birth = Date.parse(arg)
    end

  end

end

require "familial/date"
require "familial/record"
require "familial/sex"

module Familial

  class Individual < Record

    attr_accessor :name

    def date_of_birth=(arg)
      @date_of_birth = Date.parse(arg)
    end

    attr_reader :date_of_birth

    def date_of_death=(arg)
      @date_of_death = Date.parse(arg)
    end

    attr_reader :date_of_death

    def sex=(arg)
      @sex = Familial::Sex.fetch(arg)
    end

    attr_reader :sex

  end

end

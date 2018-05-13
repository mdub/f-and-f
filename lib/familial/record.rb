require "familial/chiller"

module Familial

  class Record

    include Chiller

    def initialize(dataset:, id:)
      @dataset = dataset
      @id = chill(id)
    end

    attr_reader :id

  end

end

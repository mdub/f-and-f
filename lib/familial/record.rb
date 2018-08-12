require "familial/chiller"

module Familial

  class Record

    include Chiller

    def initialize(dataset:, id:)
      @dataset = dataset
      @id = chill(id)
    end

    attr_reader :id

    def update(attributes)
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
      self
    end

  end

end

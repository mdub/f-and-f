require "familial/chiller"
require "stringio"

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

    def to_gedcom
      b = StringIO.new
      write_gedcom(b)
      b.string
    end

  end

end

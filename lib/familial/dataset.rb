require "familial/collection"
require "familial/individual"
require "forwardable"

module Familial

  class Dataset

    def individuals
      @individuals ||= collection_of(Individual)
    end

    def find(name)
      individuals.detect do |i|
        i.name == name
      end
    end

    private

    def collection_of(record_class)
      Collection.new(item_class: record_class, dataset: self)
    end

  end

end

require "familial/collection"
require "familial/family"
require "familial/individual"
require "forwardable"

module Familial

  class Dataset

    def individuals
      @individuals ||= collection_of(Individual)
    end

    def find(name)
      individuals.detect do |i|
        i.name.casecmp(name) == 0
      end
    end

    def families
      @families ||= collection_of(Family)
    end

    def write_gedcom(out)
      individuals.each do |i|
        i.write_gedcom(out)
      end
      families.each do |f|
        f.write_gedcom(out)
      end
    end

    private

    def collection_of(record_class)
      Collection.new(item_class: record_class, dataset: self)
    end

  end

end

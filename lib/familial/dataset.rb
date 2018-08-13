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
      out.puts <<~GEDCOM
        0 HEAD
        1 GEDC
        2 VERS 5.5
        2 FORM LINEAGE-LINKED
        1 CHAR UTF-8
        1 LANG English
        1 SUBM @SUBM@
        0 @SUBM@ SUBM
        1 NAME Mike Williams
      GEDCOM
      individuals.each do |i|
        i.write_gedcom(out)
      end
      families.each do |f|
        f.write_gedcom(out)
      end
      out.puts "0 TRLR"
    end

    private

    def collection_of(record_class)
      Collection.new(item_class: record_class, dataset: self)
    end

  end

end

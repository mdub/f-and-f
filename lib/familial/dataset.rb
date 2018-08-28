require "familial/collection"
require "familial/errors"
require "familial/family"
require "familial/individual"
require "familial/note"
require "forwardable"

module Familial

  class Dataset

    def individuals
      @individuals ||= collection_of(Individual)
    end

    def families
      @families ||= collection_of(Family)
    end

    def notes
      @notes ||= collection_of(Note)
    end

    def get(criteria)
      individuals.get(criteria)
    end

    def write_gedcom(out)
      out.puts <<~GEDCOM
        0 HEAD
        1 GEDC
        2 VERS 5.5.1
        2 FORM LINEAGE-LINKED
        1 CHAR UTF-8
        1 LANG English
        1 SUBM @SUBM@
        0 @SUBM@ SUBM
        1 NAME Mike Williams
        1 SOUR mdub/f-and-f
        2 DATA Faith and Farming, Te Huarahi Id te Ora, The Legacy of Henry Williams and William Williams
        3 DATE 1998
      GEDCOM
      [individuals, families, notes].each do |collection|
        collection.each do |record|
          record.write_gedcom(out)
        end
      end
      out.puts "0 TRLR"
    end

    private

    def collection_of(record_class)
      Collection.new(item_class: record_class, dataset: self)
    end

  end

end

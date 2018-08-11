require "familial/dataset"

module FaithAndFarming

  class TreeBuilder

    def initialize
      @db = Familial::Dataset.new
    end

    attr_reader :db

    def process(elements)
      elements.each do |e|
        case e
        when FaithAndFarming::Book::Elements::Entry
          add_entry(e)
        end
      end
      self
    end

    private

    def add_entry(entry)
      entry.people.each do |person|
        i = db.individuals.create
        i.name = person.name.gsub(/\w+/) { |w| w.capitalize }
        i.date_of_birth = person.date_of_birth if person.date_of_birth
        i.date_of_death = person.date_of_death if person.date_of_death
      end
    end

  end

end

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
      individuals = entry.people.map do |person|
        db.individuals.create.tap do |i|
          i.name = normalise_name(person.name)
          i.date_of_birth = person.date_of_birth if person.date_of_birth
          i.date_of_death = person.date_of_death if person.date_of_death
        end
      end
      if individuals.size == 2
        db.families.create.tap do |f|
          f.date_married = entry.date_married if entry.date_married
        end
      end
    end

    def normalise_name(name)
      name.split(", ").reverse.join(" ")
    end

  end

end

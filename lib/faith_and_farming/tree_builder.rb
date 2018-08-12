require "familial/dataset"
require "gender_detector"

module FaithAndFarming

  class TreeBuilder

    def initialize
      @db = Familial::Dataset.new
      @family_stack = []
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

    def self.gender_detector
      @gender_detector ||= GenderDetector.new
    end

    private

    def add_entry(entry)
      pop_to_level(entry.level)
      individuals = entry.people.map(&method(:individual_from))
      unless family_stack.empty?
        current_family.add_child(individuals.first)
      end
      if individuals.size == 2
        db.families.create.tap do |f|
          f.date_married = entry.date_married if entry.date_married
          wife_and_husband = individuals.sort_by { |i| (i.sex || "g").to_s }
          f.wife = wife_and_husband[0]
          f.husband = wife_and_husband[1]
          set_current_family(f, level: entry.level)
        end
      end
    end

    def individual_from(person)
      db.individuals.create.tap do |i|
        person.name =~ /^(\w+), (.+?)(?: \((\w+)\))?$/
        i.name = [$2, $1].join(" ")
        i.nickname = $3
        assumed_gender = guess_gender(i.name.split(" ").first)
        i.sex = assumed_gender if assumed_gender
        i.date_of_birth = person.date_of_birth if person.date_of_birth
        i.date_of_death = person.date_of_death if person.date_of_death
      end
    end

    def guess_gender(name)
      result = self.class.gender_detector.get_gender(name)
      return nil if result == :andy
      result.to_s.sub(/^mostly_/,'')
    end

    attr_reader :family_stack

    StackEntry = Struct.new(:family, :level)

    def pop_to_level(level)
      while family_stack.any? && level <= family_stack.last.level
        family_stack.pop
      end
    end

    def set_current_family(family, level:)
      family_stack.push(StackEntry.new(family, level))
    end

    def current_family
      family_stack.last.family
    end

  end

end

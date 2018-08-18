require "familial/dataset"
require "gender_detector"

module FaithAndFarming

  class TreeBuilder

    def initialize
      @db = Familial::Dataset.new
      @family_stack = []
      @page_index = "-"
      @entry_index = 0
    end

    attr_reader :db

    def process(elements)
      elements.each do |e|
        case e
        when FaithAndFarming::Book::Elements::StartOfPage
          self.page_index = e.page_index
          self.entry_index = 0
        when FaithAndFarming::Book::Elements::Entry
          add_entry(e)
        end
      end
      self
    end

    def self.gender_detector
      @gender_detector ||= GenderDetector.new
    end

    protected

    attr_accessor :page_index
    attr_accessor :entry_index

    private

    def add_entry(entry)
      pop_to_level(entry.level)
      self.entry_index += 1
      base_id = "p#{page_index}.e#{entry_index}"
      individuals = entry.people.each_with_index.map do |person, i|
        individual_from(person, id: "I#{base_id}.i#{i+1}")
      end
      unless family_stack.empty?
        current_family.add_child(individuals.first)
      end
      if individuals.size == 2
        f = marriage_of(individuals, id: "F#{base_id}")
        f.date_married = entry.date_married if entry.date_married
        set_current_family(f, level: entry.level)
      end
      unless entry.note.nil? || entry.note.strip.empty?
        note = db.notes.create(id: "N#{base_id}", content: entry.note)
        individuals.each { |i| i.note = note }
      end
    end

    def individual_from(person, id:)
      name, nickname = parse_name(person.name)
      date_of_birth = Familial::Date.parse(person.date_of_birth) if person.date_of_birth
      existing = db.individuals.with(name: name, date_of_birth: date_of_birth).first
      return existing if existing
      db.individuals.create(id: id).tap do |i|
        i.name = name
        i.nickname = nickname
        assumed_gender = guess_gender(name.split(" ").first)
        i.sex = assumed_gender if assumed_gender
        i.date_of_birth = person.date_of_birth if person.date_of_birth
        i.date_of_death = person.date_of_death if person.date_of_death
      end
    end

    def marriage_of(individuals, id:)
      wife, husband = individuals.sort_by { |i| (i.sex || "g").to_s }
      existing = wife.families.detect { |f| f.husband == husband }
      return existing if existing
      db.families.create(id: id, wife: wife, husband: husband)
    end

    def parse_name(person_name)
      name = person_name.dup
      nickname = nil
      if name.sub!(/ \((\w+)\)$/, '')
        nickname = $1
      end
      last, rest = name.split(", ", 2)
      name = "#{rest} /#{last}/"
      [name, nickname]
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

require "familial/dataset"
require "faith_and_farming/sex_guesser"

module FaithAndFarming

  class TreeBuilder

    def initialize
      @db = Familial::Dataset.new
      @stack = []
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
        when FaithAndFarming::Book::Elements::Continuation
          append_continuation(e)
        end
      end
      self
    end

    def self.sex_guesser
      @sex_guesser ||= SexGuesser.uk
    end

    protected

    attr_accessor :page_index
    attr_accessor :entry_index
    attr_accessor :last_note

    private

    def add_entry(entry)
      pop_context_to(level: entry.level - 1)
      self.entry_index += 1
      base_id = "p#{page_index}.e#{entry_index}"
      individuals = entry.people.each_with_index.map do |person, i|
        individual_from(person, id: "I#{base_id}.i#{i+1}")
      end
      current_family.add_child(individuals.first) if current_family
      if individuals.size == 2
        f = marriage_of(individuals, id: "F#{base_id}")
        f.date_married = entry.date_married if entry.date_married
        push_context(f, level: entry.level)
      else
        push_context(individuals.first, level: entry.level)
      end
      self.last_note = nil
      unless entry.note.nil? || entry.note.strip.empty?
        note = db.notes.create(id: "N#{base_id}", content: entry.note)
        individuals.each { |i| i.notes << note }
        self.last_note = note
      end
    end

    CONTINUATION_MARKER = "(cont...)\n"

    def append_continuation(entry)
      return false if last_note.nil?
      last_note.content = last_note.content.sub(CONTINUATION_MARKER,"") + entry.text
    end

    def individual_from(person, id:)
      name, nickname = parse_name(person.name)
      date_of_birth = Familial::Date.parse(person.date_of_birth) if person.date_of_birth
      existing = db.individuals.with(name: name, date_of_birth: date_of_birth).first
      return existing if existing
      db.individuals.create(id: id).tap do |i|
        i.name = name
        i.nickname = nickname
        assumed_gender = guess_sex(name.split(" ").first)
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
      name.sub!(" /??/", "")
      [name, nickname]
    end

    attr_reader :stack

    StackEntry = Struct.new(:record, :level)

    def pop_context_to(level:)
      while stack.any? && stack.last.level > level
        stack.pop
      end
    end

    def push_context(record, level:)
      stack.push(StackEntry.new(record, level))
    end

    def current_family
      return nil if stack.empty?
      ensure_context_is_a_family
      stack.last.record
    end

    def ensure_context_is_a_family
      return if stack.last.record.kind_of?(Familial::Family)
      current = stack.pop
      i = current.record
      family = db.families.create(id: i.id.sub('I', 'F'))
      if i.sex&.male?
        family.husband = i
      else
        family.wife = i
      end
      push_context(family, level: current.level)
    end

    def guess_sex(name)
      self.class.sex_guesser.guess_sex(name)
    end

  end

end

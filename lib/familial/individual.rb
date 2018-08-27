require "familial/date"
require "familial/record"
require "familial/sex"

module Familial

  class Individual < Record

    attr_accessor :name
    attr_accessor :nickname

    def date_of_birth=(arg)
      @date_of_birth = Date.parse(arg)
    end

    attr_reader :date_of_birth

    def date_of_death=(arg)
      @date_of_death = Date.parse(arg)
    end

    attr_reader :date_of_death

    def sex=(arg)
      @sex = Familial::Sex.fetch(arg)
    end

    attr_reader :sex

    attr_accessor :parents

    def father
      parents&.husband
    end

    def mother
      parents&.wife
    end

    def families
      @families ||= []
    end

    def children
      families.flat_map(&:children)
    end

    def notes
      @notes ||= []
    end

    def note_content
      notes.map(&:content).join
    end

    def write_gedcom(out)
      out.puts "0 @#{id}@ INDI"
      out.puts "1 NAME #{name}"
      out.puts "2 NICK #{nickname}" unless nickname.nil?
      out.puts "1 SEX #{sex.to_gedcom}" unless sex.nil?
      unless date_of_birth.nil?
        out.puts "1 BIRT"
        out.puts "2 DATE #{date_of_birth.to_gedcom}"
      end
      unless date_of_death.nil?
        out.puts "1 DEAT"
        out.puts "2 DATE #{date_of_death.to_gedcom}"
      end
      out.puts "1 FAMC @#{parents.id}@" unless parents.nil?
      families.each do |family|
        out.puts "1 FAMS @#{family.id}@"
      end
      notes.each do |note|
        out.puts "1 NOTE @#{note.id}@"
      end
    end

    def name_matches?(other_name)
      name.casecmp(other_name) == 0
    end

    def inspect
      "<Individual @name=#{name.inspect}>"
    end

  end

end

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

    def families
      @families ||= []
    end

    attr_accessor :note

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
      out.puts "1 NOTE @#{note.id}@" unless note.nil?
    end

    def name_matches?(other_name)
      name.casecmp(other_name) == 0
    end

  end

end

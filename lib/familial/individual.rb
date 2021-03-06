require "familial/date"
require "familial/record"
require "familial/sex"

module Familial

  class Individual < Record

    attr_accessor :name
    attr_accessor :nickname

    def given_names
      name.sub(%r{ /.*}, "")
    end

    def date_of_birth=(arg)
      @date_of_birth = Date.parse(arg)
    end

    attr_reader :date_of_birth

    def date_of_death=(arg)
      @date_of_death = Date.parse(arg)
    end

    attr_reader :date_of_death

    def sex=(arg)
      @sex = (Familial::Sex.fetch(arg) unless arg.nil?)
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

    def problems
      [].tap do |problems|
        problems << "sex is unspecified" if sex.nil?
        %w(mother father).each do |relationship|
          parent = public_send(relationship)
          next if parent.nil?
          if date_of_birth
            if parent.date_of_birth
              parents_age_at_birth = date_of_birth.days_after(parent.date_of_birth) / 365
              if parents_age_at_birth < 14
                problems << "born when #{relationship} (#{parent.id}) was only #{parents_age_at_birth}"
              end
              if parents_age_at_birth > 75
                problems << "born when #{relationship} (#{parent.id}) was #{parents_age_at_birth}"
              end
            end
            if parent.date_of_death
              age_in_days_when_parent_died = parent.date_of_death.days_after(date_of_birth)
              if age_in_days_when_parent_died < -270
                problems << "born when #{relationship} (#{parent.id}) was dead"
              end
            end
          end
        end
      end
    end

    private

    def years_between(start_date, end_date)
      return nil unless start_date && end_date
      (end_date.to_date - start_date.to_date).to_i / 365
    end

  end

end

require "familial/date"
require "familial/record"

module Familial

  class Family < Record

    def initialize(*args)
      super
      @children = []
    end

    def date_married=(arg)
      @date_married = Date.parse(arg)
    end

    attr_reader :date_married

    def husband=(individual)
      individual.families << self
      @husband = individual
    end

    attr_reader :husband

    def wife=(individual)
      individual.families << self
      @wife = individual
    end

    attr_reader :wife

    def add_child(individual)
      unless individual.parents == self
        individual.parents = self
        @children << individual
      end
      self
    end

    def parents
      [husband, wife].compact
    end

    def children
      @children.dup
    end

    def write_gedcom(out)
      out.puts "0 @#{id}@ FAM"
      out.puts "1 HUSB @#{husband.id}@" unless husband.nil?
      out.puts "1 WIFE @#{wife.id}@" unless wife.nil?
      unless date_married.nil?
        out.puts "1 MARR"
        out.puts "2 DATE #{date_married.to_gedcom}"
      end
      children.each do |child|
        out.puts "1 CHIL @#{child.id}@"
      end
    end

    def problems
      [].tap do |problems|
        problems << "husband is female" if husband&.sex&.female?
        problems << "wife is male" if wife&.sex&.male?
        %w(husband wife).each do |role|
          partner = public_send(role)
          if date_married && partner.date_of_birth
            age_at_marriage = date_married.days_after(partner.date_of_birth) / 365
            problems << "#{role} married at age #{age_at_marriage}" if age_at_marriage < 14
          end
        end
        child_birth_dates = children.map(&:date_of_birth).compact
        unless child_birth_dates == child_birth_dates.sort
          problems << "children are not in birth order"
        end
      end
    end

  end

end

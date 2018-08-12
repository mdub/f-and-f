require "familial/date"
require "familial/record"

module Familial

  class Family < Record

    def date_married=(arg)
      @date_married = Date.parse(arg)
    end

    attr_reader :date_married

    attr_accessor :husband
    attr_accessor :wife

    def children
      @children ||= []
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

  end

end

require "date"

module Familial

  class Date < Struct.new(:year, :month, :day)

    def initialize(year, month = nil, day = nil)
      super(year, month, day)
    end

    def to_s
      ("%02d.%02d.%04d" % [day || 99, month || 99, year || 9999]).gsub("99", "**")
    end

    def to_date
      ::Date.new(year, month || 1, day || 1)
    end

    MONTHS = %w(JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC)

    def to_gedcom
      parts = []
      parts << day.to_s unless day.nil?
      parts << MONTHS[month-1] unless month.nil?
      parts << ("%04d" % year)
      parts.join(" ")
    end

    PATTERN = %r{^([\d*]{2})\.([\d*]{2})\.([\d*]{4})$}

    class << self

      def parse(date_string)
        raise ArgumentError, "invalid date: #{date_string}" unless date_string =~ PATTERN
        fields = Regexp.last_match.captures.reverse.map do |field|
          Integer(field.sub(/^0/,"")) unless field =~ /^\*+$/
        end
        new(*fields)
      end

    end

  end

end

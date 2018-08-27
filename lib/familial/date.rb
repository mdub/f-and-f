require "date"

module Familial

  class Date < Struct.new(:year, :month, :day, :approximate)

    def initialize(year, month = nil, day = nil, approximate: false)
      super(year, month, day, approximate)
    end

    def to_s
      ("%02d.%02d.%04d" % [day || 99, month || 99, year || 9999]).gsub("99", "**")
    end

    def to_date
      ::Date.new(year, month || 1, day || 1)
    end

    alias_method :approximate?, :approximate

    MONTHS = %w(JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC)

    def to_gedcom
      parts = []
      parts << "ABT" if approximate?
      parts << day.to_s unless day.nil?
      parts << MONTHS[month-1] unless month.nil?
      parts << ("%04d" % year)
      parts.join(" ")
    end

    class << self

      def parse(date_string)
        case date_string
        when %r{^circa ([\d*]{4})$}
          new(Integer($1), approximate: true)
        when %r{^?([\d*]{2})\.([\d*]{2})\.([\d*]{4})$}
          year_month_day = Regexp.last_match.captures.reverse.map do |field|
            Integer(field.sub(/^0/,"")) unless field =~ /^\*+$/
          end
          return nil if year_month_day.first.nil?
          new(*year_month_day)
        else
          raise ArgumentError, "invalid date: #{date_string}"
        end
      end

    end

  end

end

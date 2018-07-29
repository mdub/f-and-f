require "faith_and_farming/book/elements/entry"

module FaithAndFarming
  module Book

    class EntryParser

      def self.parse(*args)
        new.parse(*args)
      end

      def parse(text)
        lines = text.lines
        return nil unless lines.shift =~ /^0[1-9]> (.*)/
        first, married, second = $1.split(/ (m .* to|de facto) /i, 2)
        names = [first, second].compact
        Elements::Entry.new.tap do |e|
          if married =~ /m on (.*) to/i
            e.marriage_date = $1
          end
          names.each_with_index do |name, i|
            e.people[i].name = name.sub(/^\(\d\)/,"")
            if lines.shift =~ /^b ([\d*.]+)(?: d ([\d*.]+))?/
              e.people[i].date_of_birth = $1
              e.people[i].date_of_death = $2
            end
          end
          e.note = lines.join unless lines.empty?
        end
      end

    end

  end
end

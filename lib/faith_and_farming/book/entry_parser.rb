require "faith_and_farming/book/elements/entry"

module FaithAndFarming
  module Book

    class EntryParser

      def self.parse(*args)
        new.parse(*args)
      end

      def parse(text)
        return nil unless text =~ /\A0[1-9]> (.*)/
        Elements::Entry.new.tap do |e|
          left, married, right = $1.split(/ (m .* to|de facto) /i, 2)
          names = [left, right].compact
          if married =~ /m on (.*) to/i
            e.marriage_date = $1
          end
          names.each_with_index do |name, i|
            e.people[i].name = name.sub(/^\(\d\)/,"")
            if text.lines[i+1] =~ /^b ([\d*.]+)(?: d ([\d*.]+))?/
              e.people[i].date_of_birth = $1
              e.people[i].date_of_death = $2
            end
          end
        end
      end

    end

  end
end

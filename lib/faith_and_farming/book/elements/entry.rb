require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Entry < ConfigMapper::ConfigStruct

        component_list :people do
          attribute :name
          attribute :date_of_birth, :default => nil
          attribute :date_of_death, :default => nil
        end

        def subject
          people[0]
        end

        attribute :level, Integer
        attribute :marriage_date, :default => nil
        attribute :note, :default => nil

        def to_h
          {
            "level" => level,
            "marriage_date" => marriage_date,
            "people" => people.map(&:to_h),
            "note" => note
          }
        end

        class << self

          def from(text)
            lines = text.lines
            return nil unless lines.shift =~ /^0[1-9]> (.*)/
            first, married, second = $1.split(/ (m .* to|de facto) /i, 2)
            names = [first, second].compact
            new.tap do |e|
              if married =~ /m on (.*) to/i
                e.marriage_date = normalise_date($1)
              end
              names.each_with_index do |name, i|
                e.people[i].name = name.sub(/^\(\d\) */,"")
                if lines.shift =~ /^b ([\d*. ]+)(?: d ([\d*. ]+))?$/
                  e.people[i].date_of_birth = normalise_date($1)
                  e.people[i].date_of_death = normalise_date($2)
                end
              end
              e.note = lines.join unless lines.empty?
            end
          end

          def normalise_date(date_string)
            return nil if date_string.nil?
            date_string.gsub("* *", "*.*")
          end

        end

      end

    end
  end
end

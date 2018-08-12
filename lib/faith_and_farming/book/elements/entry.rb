require "config_mapper"
require "faith_and_farming/book/utils"

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
        attribute :date_married, :default => nil
        attribute :note, :default => nil

        def to_h
          {
            "level" => level,
            "date_married" => date_married,
            "people" => people.map(&:to_h),
            "note" => note
          }
        end

        class << self

          def from(text)
            lines = text.lines
            return nil unless lines.shift =~ /^[016b][0-9]>[ ']+(.*)/
            first, married, second = $1.split(/ ?(m on .* to|de facto) /i, 2)
            names = [first, second].compact
            new.tap do |e|
              if married =~ /m on (.*) to/i
                e.date_married = normalise_date($1)
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
            Utils.normalise_date(date_string)
          end

        end

      end

    end
  end
end

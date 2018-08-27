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

        def heading
          people.map(&:name).join(" = ")
        end

        def errors
          [].tap do |errors|
            errors << "unparsed birth-date" if note =~ /^b [0-9*]/
            people.each_with_index do |person, i|
              errors << "missing date-of-birth (individual ##{i+1})" if person.date_of_birth.nil?
            end
          end
        end

        class << self

          def from(text)
            lines = text.lines
            return nil unless lines.shift =~ /^[016b][0-9]>[ ']+(.*)/
            first, married, second = $1.split(/( ?m on .* to| de facto| and) /i, 2)
            names = [first, second].compact
            new.tap do |e|
              if married =~ /m on (.*) to/i
                e.date_married = Utils.normalise_date($1)
              end
              names.each_with_index do |name, i|
                e.people[i].name = Utils.normalise_name(name.sub(/^\(\d\) */,""))
                if lines.shift =~ /^b ([\d*. ]+)(?: d ([\d*. ]+))?$/
                  e.people[i].date_of_birth = Utils.normalise_date($1)
                  e.people[i].date_of_death = Utils.normalise_date($2)
                end
              end
              e.note = lines.join unless lines.empty?
            end
          end

        end

      end

    end
  end
end

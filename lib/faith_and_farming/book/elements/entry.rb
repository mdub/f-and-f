require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Entry < ConfigMapper::ConfigStruct

        def type
          :entry
        end

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

      end

    end
  end
end

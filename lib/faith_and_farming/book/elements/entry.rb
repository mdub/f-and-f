module FaithAndFarming
  module Book
    module Elements

      class Entry < ConfigMapper::ConfigStruct

        def type
          :entry
        end

        component_list :people do
          attribute :name
          attribute :birth_date, :default => nil
          attribute :death_date, :default => nil
        end

        def subject
          people[0]
        end

        attribute :level, Integer
        attribute :marriage_date, :default => nil

        def to_h
          {
            "level" => level,
            "marriage_date" => marriage_date,
            "people" => people.map(&:to_h)
          }
        end

      end

    end
  end
end

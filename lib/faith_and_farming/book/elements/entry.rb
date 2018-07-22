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
        end

        def subject
          people[0]
        end

        attribute :level, Integer

        def to_h
          {
            "level" => level,
            "people" => people.map(&:to_h)
          }
        end

      end

    end
  end
end

module FaithAndFarming
  module Book
    module Elements

      class Entry < ConfigMapper::ConfigStruct

        component_list :people do
          attribute :name
          attribute :birth_date, :default => nil
        end

        def subject
          people[0]
        end

        attribute :level, Integer

      end

    end
  end
end

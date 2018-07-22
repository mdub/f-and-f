module FaithAndFarming
  module Book
    module Components

      class Entry < ConfigMapper::ConfigStruct

        component_list :people do
          attribute :name
        end

        def subject
          people[0]
        end

        attribute :level, Integer

      end

    end
  end
end

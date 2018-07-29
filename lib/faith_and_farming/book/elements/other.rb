require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Other < ConfigMapper::ConfigStruct

        attribute :text

        class << self

          def from(text)
            from_data(text: text)
          end

        end

      end

    end
  end
end

require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Noise < ConfigMapper::ConfigStruct

        attribute :text

        class << self

          NOISE_PATTERNS = [
            "1 2 3 4 5 6 7 8 9\n",
            /\A\d+\n\Z/
          ]

          def from(text)
            case text
            when *NOISE_PATTERNS
              from_data(text: text)
            end
          end

        end

      end

    end
  end
end

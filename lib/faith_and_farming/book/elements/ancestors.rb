require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Ancestors < ConfigMapper::ConfigStruct

        attribute :lines

        class << self

          def from(text)
            return nil unless text =~ /\ADescendants of /
            lines = text.sub(/\ADescendants of /, "").gsub(/\n[VIJ|] ?/, "\n").split("\n")
            from_data(lines: lines)
          end

        end

      end

    end
  end
end

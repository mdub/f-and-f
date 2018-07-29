require "config_mapper"

module FaithAndFarming
  module Book
    module Elements

      class Continuation < ConfigMapper::ConfigStruct

        attribute :title
        attribute :text

        class << self

          def from(text)
            return nil unless text =~ /\A(.+) \(cont\.\.\.\)\.?\n/
            new.tap do |c|
              c.title = $1
              c.text = $'
            end
          end

        end

      end

    end
  end
end

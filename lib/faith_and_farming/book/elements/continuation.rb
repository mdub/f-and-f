require "config_mapper"
require "faith_and_farming/book/utils"

module FaithAndFarming
  module Book
    module Elements

      class Continuation < ConfigMapper::ConfigStruct

        attribute :title
        attribute :text, &Utils.method(:expand_text)

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

module FaithAndFarming
  module Book
    module Elements

      class StartOfPage

        def initialize(page_index)
          @page_index = page_index
        end

        attr_reader :page_index

        def to_h
          {
            "page_index" => page_index
          }
        end

      end

    end
  end
end

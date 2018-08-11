require "faith_and_farming/book/page"

module FaithAndFarming
  module Book

    class Pages

      def initialize(page_range = (1 .. 720))
        @page_range = page_range
      end

      def each
        @page_range.each do |i|
          yield Page.load(i)
        end
      end

      include Enumerable

      def elements
        lazy.flat_map(&:elements)
      end

    end

  end
end

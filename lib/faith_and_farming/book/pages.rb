require "faith_and_farming/book/page"
require "faith_and_farming/tree_builder"

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

      def family_tree
        TreeBuilder.new.process(elements).db
      end

    end

  end
end

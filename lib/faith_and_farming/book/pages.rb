require "faith_and_farming/book/page"

module FaithAndFarming
  module Book

    class Pages

      def each_with_index
        73.upto(641) do |i|
          yield Page.load(i), i
        end
      end

    end

  end
end

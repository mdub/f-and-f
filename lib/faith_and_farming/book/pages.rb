require "faith_and_farming/book/page"

module FaithAndFarming
  module Book

    class Pages

      def each_with_index
        1.upto(720) do |i|
          yield Page.load(i), i
        end
      end

    end

  end
end

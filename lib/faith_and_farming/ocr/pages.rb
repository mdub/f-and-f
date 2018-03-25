require "faith_and_farming/ocr/page"

module FaithAndFarming
  module OCR

    class Pages

      include Enumerable

      def each
        73.upto(641) do |n|
          yield Page.load(n)
        end
      end

    end

  end
end

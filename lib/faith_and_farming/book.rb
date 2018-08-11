require "faith_and_farming/book/pages"

module FaithAndFarming
  module Book

    class << self

      def pages(*args)
        Pages.new(*args)
      end

      def family_tree(last_page: 641)
        pages(73..last_page).family_tree
      end

    end

  end
end

require "faith_and_farming/book/pages"
require "faith_and_farming/tree_builder"

module FaithAndFarming
  module Book

    class << self

      def pages(*args)
        Pages.new(*args)
      end

      def family_tree(last_page = 641)
        builder = TreeBuilder.new
        pages(73..last_page).each do |page|
          page.elements.grep(FaithAndFarming::Book::Elements::Entry).each do |entry|
            builder.add_entry(entry)
          rescue => e
            $stderr.puts "ERROR: on page #{page.page_index}"
            raise e
          end
        end
        builder.db
      end

    end

  end
end

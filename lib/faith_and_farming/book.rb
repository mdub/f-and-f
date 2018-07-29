require "faith_and_farming/book/pages"
require "familial/dataset"

module FaithAndFarming
  module Book

    class << self

      def pages(*args)
        Pages.new(*args)
      end

      def family_tree
        Familial::Dataset.new.tap do |db|
          pages(72..74).each do |page|
            page.elements.grep(FaithAndFarming::Book::Elements::Entry).each do |entry|
              entry.people.each do   |person|
                i = db.individuals.create
                i.name = person.name.gsub(/\w+/) { |w| w.capitalize }
                i.date_of_birth = person.date_of_birth if person.date_of_birth
              end
            end
          end
        end
      end

    end

  end
end

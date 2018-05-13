require "faith_and_farming/book/pages"
require "familial/dataset"

module FaithAndFarming
  module Book

    def self.family_tree
      Familial::Dataset.new.tap do |db|
        pages(72..74).each do |page|
          page.tree_entries.each do |entry|
            entry.people.each do |person|
              i = db.individuals.create
              i.name = person.name.gsub(/\w+/) { |w| w.capitalize }
            end
          end
        end
      end
    end

    def self.pages(*args)
      Pages.new(*args)
    end

  end
end

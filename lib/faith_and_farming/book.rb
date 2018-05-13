require "faith_and_farming/book/pages"
require "familial/dataset"

module FaithAndFarming
  module Book

    def self.family_tree
      Familial::Dataset.new.tap do |db|
        hw = db.individuals.create
        hw.name = "Williams, Henry"
      end
    end

    def self.pages
      Pages.new
    end

  end
end

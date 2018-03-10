require "faith_and_farming/page"

module FaithAndFarming

  class Pages
   
    include Enumerable

    def each
      73.upto(641) do |n|
        yield Page.load(n)
      end
    end

  end

end

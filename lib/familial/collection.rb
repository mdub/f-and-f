require "familial/errors"
require "forwardable"

module Familial

  class Collection

    def initialize(dataset:, item_class:)
      @dataset = dataset
      @item_class = item_class
      @items = []
    end

    extend Forwardable
    def_delegators :@items, :empty?, :size, :each

    include Enumerable

    def create(id: nil, **attributes)
      id ||= "#{type_char}#{items.size + 1}"
      new_item = item_class.new(dataset: dataset, id: id)
      items << new_item
      new_item.update(attributes)
      new_item
    end

    def with(criteria)
      select do |item|
        criteria.all? do |property, value|
          value === item.public_send(property)
        end
      end
    end

    def get(criteria)
      found_item = with(criteria).first
      return found_item if found_item
      raise NotFound, "cannot find #{criteria}"
    end

    private

    def type_char
      item_class.name.sub(/.*::/, "")[0]
    end

    attr_reader :dataset
    attr_reader :item_class
    attr_reader :items

  end

end

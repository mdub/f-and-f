require "forwardable"

module Familial

  NotFound = Class.new(StandardError)

  class Collection

    def initialize(dataset:, item_class:)
      @dataset = dataset
      @item_class = item_class
      @items = []
    end

    extend Forwardable
    def_delegators :@items, :empty?, :size, :each

    include Enumerable

    def create(attributes = {})
      id = "#{type}-#{items.size + 1}"
      new_item = item_class.new(dataset: dataset, id: id)
      items << new_item
      new_item.update(attributes)
      new_item
    end

    def resolve(id)
      found_item = items.detect { |i| i.id == id }
      return found_item if found_item
      raise NotFound, "cannot resolve #{id}"
    end

    private

    def type
      item_class.name.sub(/.*::/, "").to_sym
    end

    attr_reader :dataset
    attr_reader :item_class
    attr_reader :items

  end

end

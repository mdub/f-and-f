require "config_mapper"
require "yaml"

module FaithAndFarming

  class Element < ConfigMapper::ConfigStruct

    attribute :languages
    attribute :break_type, :default => nil
    attribute :prefix_break, :default => nil
    component_list :bounds do
      attribute :x
      attribute :y
    end

    def left
      bounds.map(&:x).min
    end

    def right
      bounds.map(&:x).max
    end

  end

  class Symbol < Element
    attribute :text
  end

  class Word < Element

    def text
      symbols.map(&:text).join
    end

    component_list :symbols, type: Symbol

  end

  class Paragraph < Element

    BREAKS = {
      :SPACE => " ",
      :LINE_BREAK => "\n",
      :EOL_SURE_SPACE => "\n"
    }

    def text
      @text ||= _text
    end

    def _text
      buffer = ""
      words.each do |w|
        w.symbols.each do |s|
          buffer << s.text
          buffer << BREAKS.fetch(s.break_type, "")
        end
      end
      buffer
    end

    component_list :words, type: Word

  end

  class Block < Element

    attribute :block_type

    def text
      paragraphs.map(&:text).join
    end

    component_list :paragraphs, type: Paragraph

  end

  class Page < Element

    def self.load(page_no)
      file = File.expand_path("../../../data/page-#{"%03d" % page_no}.yml", __FILE__)
      page_data = YAML.load_file(file).fetch(:pages).first
      result = from_data(page_data)
      result.page_no = page_no
      result
    end

    attr_accessor :page_no

    attribute :width
    attribute :height

    component_list :blocks, type: Block

  end

end
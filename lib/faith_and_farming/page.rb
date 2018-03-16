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

    def descendants_of
      @descendants_of ||= begin
        text = blocks.take(3).map(&:text).grep(/^Descendants of /).first
        return nil unless text
        text = text.sub(/^Descendants of /, "").gsub(/^[IJ]/, "")
        text.split("\n")
      end
    end

    def tree_entries
      @tree_entries ||= [].tap do |y|
        blocks.each do |block|
          if block.text =~ /\A0[1-9]> (.*)/
            y << Entry.new.tap do |e|
              e.subject.name = $1
              e.level = calculate_level(block.left)
            end
          end
        end
      end
    end

    def entry_offset
      unless defined?(@entry_offset)
        @entry_offset = nil
        blocks.each do |b|
          if b.text =~ /^1 2 3 4/
            @entry_offset = b.left
            break_type
          end
        end
      end
      @entry_offset 
    end

    # p222
    # - key: 201 
    # - L2: 272, 272, 268, 272
    # - L3: 349, 344
    # - L5: 493
    # - L6: 571
    def calculate_level(left)
      (left - entry_offset + 35) / 75 + 1
    end

  end

  class Entry < ConfigMapper::ConfigStruct

    component_list :people do
      attribute :name
    end

    def subject
      people[0]
    end

    attribute :level, Integer

  end

end
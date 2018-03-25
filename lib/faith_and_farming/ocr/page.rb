require "config_mapper"
require "yaml"

module FaithAndFarming
  module OCR

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

      def top
        bounds.map(&:y).min
      end

      def bottom
        bounds.map(&:y).max
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

      GCV_DATA = File.expand_path("../../../../book/gcv-data", __FILE__)

      def self.load(page_index)
        file = File.join(GCV_DATA, ("page-%03d.yml" % page_index))
        page_data = YAML.load_file(file).fetch(:pages).first
        result = from_data(page_data)
        result.page_index = page_index
        result
      end

      attr_accessor :page_index

      attribute :width
      attribute :height

      component_list :blocks, type: Block

    end

  end
end

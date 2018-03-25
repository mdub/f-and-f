require "config_mapper"
require "faith_and_farming/ocr/page"
require "yaml"

module FaithAndFarming
  module Book

    class Bounds < ConfigMapper::ConfigStruct

      attribute :left, Integer
      attribute :right, Integer
      attribute :top, Integer
      attribute :bottom, Integer

      def self.encompassing(bs)
        new.tap do |bounds|
          bounds.left = bs.map(&:left).min
          bounds.right = bs.map(&:right).max
          bounds.top = bs.map(&:top).min
          bounds.bottom = bs.map(&:bottom).max
        end
      end

    end

    class Page < ConfigMapper::ConfigStruct

      PAGE_CACHE = File.expand_path("../../../../book/cache", __FILE__)

      def self.load(page_index)
        ocr_page = FaithAndFarming::OCR::Page.load(page_index)
        from_ocr(ocr_page)
      end

      def self.from_ocr(ocr_page)
        new.tap do |page|
          ocr_page.blocks.each_with_index do |ocr_block, i|
            ocr_block.paragraphs.each_with_index do |ocr_p, j|
              p = page.blocks[i].paragraphs[j]
              p.text = ocr_p.text
              %w(left right top bottom).each do |field|
                p.bounds.public_send("#{field}=", ocr_p.public_send(field))
              end
            end
          end
        end
      end

      attr_accessor :page_index

      component_list :blocks do

        def text
          paragraphs.map(&:text).join
        end

        component_list :paragraphs do

          attribute :text

          component :bounds, type: Bounds

        end

        def bounds
          Bounds.encompassing(paragraphs.map(&:bounds))
        end

      end

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
                e.level = calculate_level(block.bounds.left)
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
              @entry_offset = b.bounds.left
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
end

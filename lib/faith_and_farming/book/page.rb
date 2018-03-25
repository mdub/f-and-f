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

      end

    end

  end
end

require "config_mapper"
require "faith_and_farming/book/elements/ancestors"
require "faith_and_farming/book/elements/entry"
require "faith_and_farming/ocr/page"
require "yaml"

module FaithAndFarming
  module Book

    class Bounds < ConfigMapper::ConfigStruct

      attribute :left, Integer
      attribute :right, Integer
      attribute :top, Integer
      attribute :bottom, Integer

      alias_method :to_data, :to_h

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

      class << self

        def load(page_index)
          load_raw(page_index).tap do |page|
            page.page_index = page_index
          end
        end

        def load_raw(page_index)
          cache_file = File.join(PAGE_CACHE, ("page-%03d.yml" % page_index))
          if File.exist?(cache_file)
            return from_data(YAML.load_file(cache_file))
          end
          ocr_page = FaithAndFarming::OCR::Page.load(page_index)
          from_ocr(ocr_page).tap do |page|
            File.write(cache_file, YAML.dump(page.to_data))
          end
        end

        def from_ocr(ocr_page)
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

      end

      attr_accessor :page_index

      component_list :blocks do

        component_list :paragraphs do

          attribute :text

          component :bounds, type: Bounds

          def to_data
            {
              "text" => text,
              "bounds" => bounds.to_data
            }
          end

        end

        def text
          paragraphs.map(&:text).join
        end

        def to_data
          {
            "paragraphs" => paragraphs.map(&:to_data)
          }
        end

        def bounds
          Bounds.encompassing(paragraphs.map(&:bounds))
        end

      end

      def to_data
        {
          "blocks" => blocks.map(&:to_data)
        }
      end

      def entry_offset
        return @entry_offset if defined?(@entry_offset)
        blocks.each do |b|
          if b.text =~ /^1 2 3 4/
            return @entry_offset = b.bounds.left
          end
        end
        @entry_offset = nil
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

      def elements
        [].tap do |y|
          blocks.each_with_index do |block, i|
            text = block.text
            if i < 3 && text =~ /^Descendants of /
              lines = text.sub(/^Descendants of /, "").gsub(/^[IJ]/, "").split("\n")
              y << Elements::Ancestors.from_data(lines: lines)
            elsif text =~ /\A0[1-9]> (.*)/
              y << Elements::Entry.new.tap do |e|
                $1.split(/ m on .* to /).each_with_index do |name, i|
                  e.people[i].name = name
                end
                e.level = calculate_level(block.bounds.left)
                if text.lines[1] =~ /^b ([\d*.]+)/
                  e.people[0].birth_date = $1
                end
                if text.lines[2] =~ /^b ([\d*.]+)/
                  e.people[1].birth_date = $1
                end
              end
            end
          end
        end
      end

    end

  end
end

require "config_mapper"
require "yaml"

module FaithAndFarming

  module Element

    def self.included(target)
      target.class_eval do
        attribute :languages
        attribute :break_type, :default => nil
        attribute :prefix_break, :default => nil
        component_list :bounds do 
          attribute :x
          attribute :y
        end
      end
    end

  end

  class Page < ConfigMapper::ConfigStruct

    def self.load(number)
      file = File.expand_path("../../../data/page-#{"%03d" % number}.yml", __FILE__)
      page_data = YAML.load_file(file).fetch(:pages).first
      from_data(page_data)
    end

    include Element

    attribute :width
    attribute :height

    component_list :blocks do 

      include Element

      attribute :block_type

      component_list :paragraphs do 

        include Element

        BREAKS = {
          :SPACE => " ",
          :LINE_BREAK => "\n",
          :EOL_SURE_SPACE => "\n"
        }

        def text
          buffer = ""
          words.each do |w|
            w.symbols.each do |s|
              buffer << s.text
              buffer << BREAKS.fetch(s.break_type, "")
            end
          end
          buffer
        end

        component_list :words do 

          include Element

          def text
            symbols.map(&:text).join
          end
            
          component_list :symbols do 

            include Element

            attribute :text

          end

        end

      end

    end
    
  end

end
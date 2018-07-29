
module FaithAndFarming
  module Book

    module Utils

      extend self

      def normalise_date(date_string)
        return nil if date_string.nil?
        date_string
          .sub(/\.$/,"")
          .gsub("** ", "**.")
          .gsub("****.", "**.**.")
          .sub("********", "**.**.****")
          .gsub(". ", ".")
      end

    end

  end
end

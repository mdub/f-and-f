
module FaithAndFarming
  module Book

    module Utils

      extend self

      def normalise_date(date_string)
        return nil if date_string.nil?
        date_string
          .sub(/\.$/,"")
          .gsub("** , ", "**.")
          .gsub("**, ", "**.")
          .gsub("** ", "**.")
          .gsub("****.", "**.**.")
          .sub("********", "**.**.****")
          .gsub(". ", ".")
      end

      def normalise_name(name)
        name
          .sub(/ ?- ?/, "-")
          .gsub(/\p{Latin}+/, &:capitalize)
          .sub("Van Der", "van der")
          .sub(/Mc([a-z])/) { "Mc" + $1.upcase }
      end

    end

  end
end

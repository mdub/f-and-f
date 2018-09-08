
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
          .sub(" ****", ".****")
      end

      def normalise_name(name)
        name
          .sub(/ ?- ?/, "-")
          .sub(" ,", ",")
          .gsub(/\p{Latin}+/, &:capitalize)
          .sub("Van Der", "van der")
          .sub(/Mc([a-z])/) { "Mc" + $1.upcase }
      end

      EVENT_ABBREVS = {
        "b" => "born",
        "m" => "married",
        "d" => "died",
        "bd" => "buried",
      }

      def expand_text(text)
        text.gsub(/\b(b|m|d|bd)[.,] (at|and)\b/) do
          EVENT_ABBREVS.fetch($1) + " " + $2
        end
      end

    end

  end
end

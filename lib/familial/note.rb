require "familial/record"

module Familial

  class Note < Record

    attr_accessor :content

    def write_gedcom(out)
      out.puts "0 @#{id}@ NOTE"
      content.lines.each do |line|
        out.puts "1 CONT #{line}"
      end
    end

  end

end

require "gender_detector"

module FaithAndFarming

  class SexGuesser

    def initialize
      @gender_detector ||= GenderDetector.new
    end

    def guess_sex(name)
      result = gender_detector.get_gender(name)
      return nil if result == :andy
      result.to_s.sub(/^mostly_/,'').to_sym
    end

    private

    attr_reader :gender_detector

  end

end

module FaithAndFarming

  class SexGuesser

    class << self

      def uk
        data_file = File.join(__dir__, "../../vendor/globalnamedata/assets/ukprocessed.csv")
        File.open(data_file) do |data|
          new.tap do |guesser|
            data.each_line.drop(1).each do |line|
              fields = line.sub(",,", ",").split(",")
              guesser.add_name(fields[0], fields[5])
            end
          end
        end
      end

      def nz
        uk.tap do |guesser|
          guesser.add_name("Barthold", 0.8)
          guesser.add_name("Cathrin", 0.2)
          guesser.add_name("Cecil", 0.55)
          guesser.add_name("Dale", 0.55)
          guesser.add_name("Delwyn", 0.5)
          guesser.add_name("Dorian", 0.55)
          guesser.add_name("Fanny", 0.1)
          guesser.add_name("Gayleen", 0)
          guesser.add_name("Jan", 0.45)
          guesser.add_name("Jean", 0.3)
          guesser.add_name("Kattlyn", 0)
          guesser.add_name("Kay", 0.4)
          guesser.add_name("Kelly", 0.45)
          guesser.add_name("Kerry", 0.4)
          guesser.add_name("Kim", 0.45)
          guesser.add_name("Lee", 0.5)
          guesser.add_name("Leslie", 0.45)
          guesser.add_name("Lindsay", 0.5)
          guesser.add_name("Maryrose", 0)
          guesser.add_name("Michele", 0.4)
          guesser.add_name("Morven", 0.3)
          guesser.add_name("Peder", 1)
          guesser.add_name("Prunella", 0)
          guesser.add_name("Raewyn", 0)
          guesser.add_name("Robin", 0.45)
          guesser.add_name("Seann", 0.4)
          guesser.add_name("Sidney", 0.55)
          guesser.add_name("Sydney", 0.45)
          guesser.add_name("Ulric", 1)
          guesser.add_name("Urma", 0)
          guesser.add_name("Wiremu", 1)
        end
      end

    end

    def initialize
      @maleness_by_name = {}
    end

    def add_name(name, maleness)
      @maleness_by_name[name.downcase] = Float(maleness)
    end

    def maleness(name)
      parts = name.downcase.split(/[ -]/)
      maleness_array = parts.map do |part|
        maleness_by_name[part]
      end
      weighted_average(maleness_array)
    end

    def guess_sex(name)
      maleness = maleness(name)
      return nil if maleness.nil?
      return :male if maleness > 0.6
      return :female if maleness < 0.4
      nil
    end

    private

    attr_reader :maleness_by_name

    def maleness_of_word(name)
      maleness_by_name[name.downcase]
    end

    def weighted_average(values)
      values = values.compact
      weighted_values = values.reverse.each_with_index.flat_map do |value, i|
        Array.new(i + 1, value)
      end
      average(weighted_values)
    end

    def average(values)
      values = values.compact
      return nil if values.empty?
      values.map(&:to_f).inject(:+) / values.size.to_f
    end

  end

end

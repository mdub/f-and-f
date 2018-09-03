module FaithAndFarming

  class SexGuesser

    def self.uk
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

    def initialize
      @maleness_by_name = {}
    end

    def add_name(name, maleness)
      @maleness_by_name[name.downcase] = Float(maleness)
    end

    def guess_sex(name)
      name = name.downcase
      maleness = maleness_by_name.fetch(name, 0.5)
      return :male if maleness > 0.6
      return :female if maleness < 0.4
      nil
    end

    private

    attr_reader :maleness_by_name

  end

end

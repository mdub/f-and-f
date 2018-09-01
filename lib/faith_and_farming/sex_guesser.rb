module FaithAndFarming

  class SexGuesser

    def initialize
      @maleness_by_name = {}
      data_file = File.join(__dir__, "../../vendor/globalnamedata/assets/ukprocessed.csv")
      File.open(data_file) do |data|
        data.each_line.drop(1).each do |line|
          fields = line.sub(",,", ",").split(",")
          @maleness_by_name[fields[0].downcase] = Float(fields[5])
        end
      end
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

require "spec_helper"

require "familial/dataset"

describe Familial::Individual do

  let(:dataset) { Familial::Dataset.new }
  subject(:individual) { dataset.individuals.create }

  describe "#sex=" do

    it "can be set using enum" do
      individual.sex = Familial::Sex.female
      expect(individual.sex).to eq(Familial::Sex.female)
    end

    it "can be set using symbol" do
      individual.sex = :male
      expect(individual.sex).to eq(Familial::Sex.male)
    end

  end

end

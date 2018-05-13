require "spec_helper"

require "familial/dataset"
require "familial/individual"

describe Familial::Dataset do

  let(:dataset) { described_class.new }

  describe "#individuals" do

    it "starts empty" do
      expect(dataset.individuals).to be_empty
    end

    describe "#create" do

      let!(:individual) { dataset.individuals.create }

      it "creates a new Individual" do
        expect(individual).to be_kind_of(Familial::Individual)
      end

      it "assigns an id" do
        expect(individual.id).to eq("Individual-1")
      end

      it "allows lookup by id" do
        expect(dataset.individuals.resolve(individual.id)).to be(individual)
      end

    end

  end

end

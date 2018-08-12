require "spec_helper"

require "familial/dataset"

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
        expect(individual.id).to eq("I1")
      end

      it "allows lookup by id" do
        expect(dataset.individuals.resolve(individual.id)).to be(individual)
      end

    end

  end

  describe "#families" do

    it "starts empty" do
      expect(dataset.families).to be_empty
    end

    describe "#create" do

      let!(:family) { dataset.families.create }

      it "creates a new family" do
        expect(family).to be_kind_of(Familial::Family)
      end

      it "assigns an id" do
        expect(family.id).to eq("F1")
      end

      it "allows lookup by id" do
        expect(dataset.families.resolve(family.id)).to be(family)
      end

    end

  end

end

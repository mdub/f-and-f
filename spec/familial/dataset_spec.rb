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
        expect(dataset.individuals.get(id: individual.id)).to be(individual)
      end

    end

    describe "#with" do

      let!(:john) do
        dataset.individuals.create(
          name: "John /Smith/",
          date_of_birth: "13.01.1945"
        )
      end

      context "with a known name" do

        it "returns the specified Individual" do
          expect(dataset.individuals.with(name: john.name)).to eq([john])
        end

        context "and correct date_of_birth" do
          it "returns the specified Individual" do
            expect(dataset.individuals.with(name: john.name, date_of_birth: john.date_of_birth)).to eq([john])
          end
        end

        context "and incorrect date_of_birth" do

          let(:bad_date) { Familial::Date.parse("12.04.1956") }

          it "returns the specified Individual" do
            expect(dataset.individuals.with(name: john.name, date_of_birth: bad_date)).to be_empty
          end

        end

      end

      context "with an unknown name" do

        it "returns nil" do
          expect(dataset.individuals.with(name: "James /Moriarty/")).to be_empty
        end

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

    end

  end

end

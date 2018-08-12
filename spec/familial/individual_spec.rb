require "spec_helper"

require "familial/dataset"

describe Familial::Individual do

  let(:dataset) { Familial::Dataset.new }
  subject(:individual) { dataset.individuals.create }

  before do
    individual.name = "Mark Willis"
    individual.sex = "male"
    individual.date_of_birth = "12.06.1981"
    individual.date_of_death = "18.01.2016"
  end

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

  describe "#to_gedcom" do

    it "generates valid GEDCOM" do
      expect(individual.to_gedcom).to eq <<~GEDCOM
        0 @I1@ INDI
        1 NAME Mark Willis
        1 SEX M
        1 BIRT
        2 DATE 12 JUN 1981
        1 DEAT
        2 DATE 18 JAN 2016
      GEDCOM
    end

  end

  context "with family ties" do

    let(:mum_and_dad) { dataset.families.create }
    let(:family_unit) { dataset.families.create }

    before do
      mum_and_dad.add_child(individual)
      family_unit.husband = individual
    end

    describe "#to_gedcom" do

      it "includes links" do
        expect(individual.to_gedcom).to include <<~GEDCOM
          1 FAMC @#{mum_and_dad.id}@
          1 FAMS @#{family_unit.id}@
        GEDCOM
      end

    end

  end

  context "with a nickname" do

    before do
      individual.nickname = "Willo"
    end

    describe "#to_gedcom" do

      it "includes nickname" do
        expect(individual.to_gedcom).to include <<~GEDCOM
          1 NAME Mark Willis
          2 NICK Willo
        GEDCOM
      end

    end

  end

end

require "spec_helper"

require "familial/dataset"

describe Familial::Individual do

  let(:dataset) { Familial::Dataset.new }
  subject(:individual) { dataset.individuals.create }

  before do
    individual.name = "Mark Anthony /Willis/"
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

  describe "#given_names" do

    it "returns all but the surname" do
      expect(individual.given_names).to eq("Mark Anthony")
    end

  end

  describe "#problems" do

    subject(:problems) { individual.problems }

    it "is usually empty" do
      expect(problems).to be_empty
    end

    it "complains when sex is unknown" do
      individual.sex = nil
      expect(problems).to include("sex is unspecified")
    end

  end

  describe "#to_gedcom" do

    it "generates valid GEDCOM" do
      expect(individual.to_gedcom).to eq <<~GEDCOM
        0 @I1@ INDI
        1 NAME Mark Anthony /Willis/
        1 SEX M
        1 BIRT
        2 DATE 12 JUN 1981
        1 DEAT
        2 DATE 18 JAN 2016
      GEDCOM
    end

  end

  context "with mum and dad" do

    let(:mum) { dataset.individuals.create(date_of_birth: "01.01.1960") }
    let(:dad) { dataset.individuals.create(date_of_birth: "01.01.1955") }
    let(:parents) { dataset.families.create(husband: dad, wife: mum) }

    before do
      parents.add_child(individual)
    end

    describe "#problems" do

      subject(:problems) do
        individual.problems.map { |s| s.sub(/\(I\d\)/, "(In)") }
      end

      it "complains when born when parent was too young" do
        individual.date_of_birth = "01.01.1980"
        mum.date_of_birth = "01.01.1970"
        expect(problems).to include("born when mother (In) was only 10")
      end

      it "complains when born when parent was too old" do
        individual.date_of_birth = "01.01.1980"
        dad.date_of_birth = "01.01.1900"
        expect(problems).to include("born when father (In) was 80")
      end

      it "complains when born when parent was dead" do
        individual.date_of_birth = "01.01.1980"
        mum.date_of_death = "01.01.1978"
        expect(problems).to include("born when mother (In) was dead")
      end

    end

    describe "#to_gedcom" do

      it "references parents" do
        expect(individual.to_gedcom).to include <<~GEDCOM
          1 FAMC @#{parents.id}@
        GEDCOM
      end

    end

  end

  context "with wife and kids" do

    let(:family) { dataset.families.create }

    before do
      family.husband = individual
    end

    describe "#to_gedcom" do

      it "references family" do
        expect(individual.to_gedcom).to include <<~GEDCOM
          1 FAMS @#{family.id}@
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
          1 NAME Mark Anthony /Willis/
          2 NICK Willo
        GEDCOM
      end

    end

  end

  context "with a note" do

    let(:blah_blah) { dataset.notes.create(content: "blah blah") }

    before do
      individual.notes << blah_blah
    end

    describe "#to_gedcom" do

      it "includes note links" do
        expect(individual.to_gedcom).to include <<~GEDCOM
          1 NOTE @#{blah_blah.id}@
        GEDCOM
      end

    end

  end

end

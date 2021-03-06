require "spec_helper"

require "familial/dataset"

describe Familial::Family do

  let(:dataset) { Familial::Dataset.new }
  subject(:family) { dataset.families.create }

  let(:bob) { dataset.individuals.create(name: "Bob") }
  let(:jane) { dataset.individuals.create(name: "Jane") }
  let(:becky) { dataset.individuals.create(name: "Becky") }
  let(:george) { dataset.individuals.create(name: "George") }

  before do
    family.date_married = "19.04.1956"
    family.husband = bob
    family.wife = jane
    family.add_child becky
    family.add_child george
  end

  it "has a husband and wife" do
    expect(family.husband).to eq(bob)
    expect(family.wife).to eq(jane)
  end

  it "has children" do
    expect(family.children.map(&:name)).to include("Becky", "George")
  end

  describe "#to_gedcom" do

    it "generates valid GEDCOM" do
      expect(family.to_gedcom).to eq <<~GEDCOM
        0 @F1@ FAM
        1 HUSB @#{bob.id}@
        1 WIFE @#{jane.id}@
        1 MARR
        2 DATE 19 APR 1956
        1 CHIL @#{becky.id}@
        1 CHIL @#{george.id}@
      GEDCOM
    end

  end

  describe "#problems" do

    subject(:problems) do
      family.problems.map { |s| s.sub(/\(I\d\)/, "(In)") }
    end

    it "is usually empty" do
      expect(problems).to be_empty
    end

    it "complains when wife is male" do
      jane.sex = :male
      expect(problems).to include("wife is male")
    end

    it "complains when husband is female" do
      bob.sex = :female
      expect(problems).to include("husband is female")
    end

    it "complains when children are out of birth order" do
      family.children[0].date_of_birth = "05.06.1978"
      family.children[1].date_of_birth = "01.02.1973"
      expect(problems).to include("children are not in birth order")
    end

    it "complains when married too young" do
      family.husband.date_of_birth = "01.02.1944"
      family.date_married = "19.04.1956"
      expect(problems).to include("husband married at age 12")
    end

  end

end

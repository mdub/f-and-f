require "spec_helper"

require "familial/date"

describe Familial::Date do

  context "with all fields specified" do

    let(:date) { described_class.new(1856, 3, 15) }

    it "exposes year" do
      expect(date.year).to eq(1856)
    end

    it "exposes month" do
      expect(date.month).to eq(3)
    end

    it "exposes day" do
      expect(date.day).to eq(15)
    end

    describe "#to_s" do
      it "has an old-school format" do
        expect(date.to_s).to eq("15.03.1856")
      end
    end

    describe "#to_date" do
      it "returns a Ruby Date" do
        expect(date.to_date).to eq(::Date.new(1856, 3, 15))
      end
    end

    describe "#to_gedcom" do
      it "returns a full GEDCOM date" do
        expect(date.to_gedcom).to eq("15 MAR 1856")
      end
    end

  end

  context "with year alone" do

    let(:date) { described_class.new(1856) }

    it "has no month" do
      expect(date.month).to be(nil)
    end

    it "has no day" do
      expect(date.day).to be(nil)
    end

    describe "#to_s" do
      it "uses asterisks for day and month" do
        expect(date.to_s).to eq("**.**.1856")
      end
    end

    describe "#to_date" do
      it "assumes day and month" do
        expect(date.to_date).to eq(::Date.new(1856, 1, 1))
      end
    end

    describe "#to_gedcom" do
      it "returns a partial GEDCOM date" do
        expect(date.to_gedcom).to eq("1856")
      end
    end

  end

  context "with month and year" do

    let(:date) { described_class.new(1856, 8) }

    describe "#to_s" do
      it "uses asterisks for day" do
        expect(date.to_s).to eq("**.08.1856")
      end
    end

    describe "#to_date" do
      it "assumes day and month" do
        expect(date.to_date).to eq(::Date.new(1856, 8, 1))
      end
    end

    describe "#to_gedcom" do
      it "returns a partial GEDCOM date" do
        expect(date.to_gedcom).to eq("AUG 1856")
      end
    end

  end

  describe ".parse" do

    context "with fully-specified date" do

      let(:date) { described_class.parse("11.09.1942") }

      it "fills all fields" do
        expect(date).to eq(described_class.new(1942, 9, 11))
      end

    end

    context "with missing day" do

      let(:date) { described_class.parse("**.04.1942") }

      it "fills month and year only" do
        expect(date).to eq(described_class.new(1942, 4, nil))
      end

    end

  end

end

# test/StatBankDenmark/Tables_test.rb

require_relative '../helper'

describe StatBankDenmark::Tables do
  context "[]" do
    it "answers a table by its id" do
      _(StatBankDenmark::Tables['STRAF42'][:name]).must_equal("Decisions, total")
    end

    it "takes the id in any case, the API naming them in capitals" do
      _(StatBankDenmark::Tables['straf42']).must_equal(StatBankDenmark::Tables['STRAF42'])
    end

    it "answers nil for one it does not know" do
      _(StatBankDenmark::Tables['NOSUCHTABLE']).must_be_nil
    end
  end

  context "dimensions" do
    it "names them as the API does" do
      _(StatBankDenmark::Tables.dimensions('STRAF10').keys).must_equal(%w{OVERTRÆD Tid})
    end

    it "marks the time dimension, there being one per table" do
      StatBankDenmark::Tables.ids.each do |id|
        timed = StatBankDenmark::Tables.dimensions(id).select{|_, detail| detail[:time]}
        _(timed.keys).must_equal(%w{Tid}, "#{id} does not mark exactly one time dimension")
      end
    end
  end

  context "column" do
    it "answers what a dimension is called once read as Ruby" do
      _(StatBankDenmark::Tables.column('STRAF42', 'HERKOMST1')).must_equal(:national_origin)
      _(StatBankDenmark::Tables.column('FOLK2', 'STATSB')).must_equal(:citizenship)
    end

    it "answers nil for a dimension the table has not got" do
      _(StatBankDenmark::Tables.column('VAN66', 'HERKOMST1')).must_be_nil
    end
  end

  # The header comment says these disagreements are real.  Were the API to settle
  # them, these would fail and the comment would want deleting rather than keeping.
  context "the disagreements the header records" do
    it "spells ancestry differently in the crime and population tables" do
      _(StatBankDenmark::Tables.dimensions('STRAF42')).must_include('HERKOMST1')
      _(StatBankDenmark::Tables.dimensions('FOLK1C')).must_include('HERKOMST')
      _(StatBankDenmark::Tables.dimensions('FOLK1C')).wont_include('HERKOMST1')
    end

    it "spells sex KOEN in STRAFNA3 and KØN everywhere else" do
      _(StatBankDenmark::Tables.dimensions('STRAFNA3')).must_include('KOEN')
      _(StatBankDenmark::Tables.dimensions('STRAF42')).must_include('KØN')
    end
  end

  context "the tables themselves" do
    it "names every one it knows" do
      _(StatBankDenmark::Tables.ids.sort).must_equal(%w{FOLK1C FOLK2 STRAF10 STRAF42 STRAFNA3 VAN66})
    end

    it "gives every dimension a name and a column" do
      StatBankDenmark::Tables.ids.each do |id|
        StatBankDenmark::Tables.dimensions(id).each do |dimension, detail|
          _(detail[:name]).wont_be_nil("#{id}/#{dimension} has no :name")
          _(detail[:as]).wont_be_nil("#{id}/#{dimension} has no :as")
        end
      end
    end
  end
end

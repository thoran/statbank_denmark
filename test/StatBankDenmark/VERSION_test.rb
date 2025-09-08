# test/StatBankDenmark/VERSION_test.rb

require_relative '../helper'

describe StatBankDenmark::VERSION do
  it "returns the version number" do
    _(StatBankDenmark::VERSION).must_match(/\d.\d.\d/)
  end
end

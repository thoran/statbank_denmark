# test/StatBankDenmark_test.rb

require_relative './test_helper'

describe StatBankDenmark do
  describe "module methods" do
    it "responds to core API methods" do
      _(StatBankDenmark).must_respond_to(:subjects)
      _(StatBankDenmark).must_respond_to(:tables)
      _(StatBankDenmark).must_respond_to(:table_info)
      _(StatBankDenmark).must_respond_to(:data)
      _(StatBankDenmark).must_respond_to(:search)
    end
  end
end

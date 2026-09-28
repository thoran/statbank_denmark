# test/StatBankDenmark_test.rb

require_relative './helper'

describe StatBankDenmark do
  describe "module methods" do
    it "responds to core API methods" do
      _(StatBankDenmark).must_respond_to(:subjects)
      _(StatBankDenmark).must_respond_to(:tables)
      _(StatBankDenmark).must_respond_to(:table_info)
      _(StatBankDenmark).must_respond_to(:data)
      _(StatBankDenmark).must_respond_to(:search)
    end

    it "answers to tableinfo, which is what the endpoint is called" do
      _(StatBankDenmark).must_respond_to(:tableinfo)
      _(StatBankDenmark.method(:tableinfo).original_name).must_equal(:table_info)
    end
  end
end

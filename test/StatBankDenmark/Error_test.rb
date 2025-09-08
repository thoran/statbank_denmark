# test/StatBankDenmark/Error_test.rb

require_relative '../helper'

describe StatBankDenmark::Error do
  context "" do
    let(:error) do
      StatBankDenmark::BadRequestError.new(
        code: 400,
        message: "Bad Request",
        body: "Invalid parameter"
      )
    end

    it "stores error details" do
      _(error.code).must_equal(400)
      _(error.message).must_equal("Bad Request")
      _(error.body).must_equal("Invalid parameter")
    end
  end

  context "" do
    let(:error) do
      StatBankDenmark::NotFoundError.new(
        code: 404,
        message: "Not Found",
        body: "Table does not exist"
      )
    end

    it "provides meaningful string representation" do
      _(error.to_s).must_equal("StatBankDenmark::NotFoundError (404): Not Found")
    end
  end

  describe "error hierarchy" do
    it "has correct inheritance" do
      _(StatBankDenmark::BadRequestError).must_be :<, StatBankDenmark::Error
      _(StatBankDenmark::NotFoundError).must_be :<, StatBankDenmark::Error
      _(StatBankDenmark::RateLimitError).must_be :<, StatBankDenmark::Error
      _(StatBankDenmark::ServerError).must_be :<, StatBankDenmark::Error
      _(StatBankDenmark::APIError).must_be :<, StatBankDenmark::Error
    end
  end
end

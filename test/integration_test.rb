# test/integration_test.rb
# Note: This test bypasses VCR and makes real API calls.

require_relative './helper'

describe "Integration Tests", :integration do
  let(:client){StatBankDenmark::Client.new}

  before do
    skip unless ENV['RUN_INTEGRATION_TESTS']
  end

  it "can fetch real data from Danish Statistics API" do
    # Test the API
    subjects = client.subjects
    _(subjects).must_be_kind_of(Array)
    _(subjects).wont_be_empty

    # Find People subject
    people_subject = subjects.find{|s| s['description']&.downcase&.include?('people')}
    skip "People subject not found" unless people_subject

    # Get People tables
    tables = client.tables(subject: people_subject['id'])
    _(tables).must_be_kind_of(Array)

    # Find FOLK1A table
    folk1a = tables.find{|t| t['id'] == 'FOLK1A'}
    skip "FOLK1A table not found" unless folk1a

    # Get table metadata
    info = client.table_info('FOLK1A')
    _(info['id']).must_equal('FOLK1A')

    # Get some actual data (limited to avoid large responses)
    data = client.data('FOLK1A', format: 'jsonstat')
    _(data).must_be_kind_of(Hash)
    _(data).wont_be_empty
  end
end

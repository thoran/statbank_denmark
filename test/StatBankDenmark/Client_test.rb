# test/StatBankDenmark/Client_test.rb

require_relative '../helper'

describe StatBankDenmark::Client do
  let(:client){StatBankDenmark::Client.new}

  describe "#subjects" do
    context "with English language" do
      let(:result){client.subjects(lang: 'en')}

      it "returns available subjects in English" do
        VCR.use_cassette("subjects_en") do
          _(result).must_be_kind_of(Array)
          _(result).wont_be_empty
          _(result.first.keys).must_include('id')
          _(result.first.keys).must_include('description')
          _(result.first.keys).must_include('active')
          _(result.first.keys).must_include('hasSubjects')
          _(result.first.keys).must_include('subjects')
        end
      end
    end

    context "with Danish language" do
      let(:result){client.subjects(lang: 'da')}

      it "returns available subjects in Danish" do
        VCR.use_cassette("subjects_da") do
          _(result).must_be_kind_of(Array)
          _(result).wont_be_empty
          _(result.first.keys).must_include('id')
          _(result.first.keys).must_include('description')
          _(result.first.keys).must_include('active')
          _(result.first.keys).must_include('hasSubjects')
          _(result.first.keys).must_include('subjects')
        end
      end
    end

    context "with recursive hierarchy enabled" do
      let(:result){client.subjects(recursive: true)}

      it "handles recursive parameter" do
        VCR.use_cassette("subjects_recursive") do
          _(result).must_be_kind_of(Array)
        end
      end
    end

    context "when API returns error" do
      it "raises BadRequestError for invalid parameters" do
        WebMock.stub_request(:get, /api\.statbank\.dk/).to_return(status: 400, body: 'Bad Request')
        _(proc{client.subjects(lang: 'invalid')}).must_raise(StatBankDenmark::BadRequestError)
      end
    end
  end

  describe "#tables" do
    context "when retrieving all tables" do
      let(:result){client.tables}

      it "returns all available tables" do
        VCR.use_cassette("tables_all") do
          _(result).must_be_kind_of(Array)
          _(result).wont_be_empty
          _(result.first).must_include('id')
          _(result.first).must_include('text')
          _(result.first).must_include('variables')
        end
      end
    end

    context "when filtering by specific subject" do
      let(:result){client.tables(subject: 4)}

      it "returns tables for crime and justice subject" do
        VCR.use_cassette("tables_subject_crime") do
          _(result).must_be_kind_of(Array)
          _(result).wont_be_empty
          crime_table = result.find{|t| t['id'] == 'STRAF42'}
          _(crime_table).wont_be_nil if crime_table
        end
      end
    end

    context "when including inactive tables" do
      let(:result){client.tables(include_inactive: true)}

      it "handles include_inactive parameter" do
        VCR.use_cassette("tables_include_inactive") do
          _(result).must_be_kind_of(Array)
        end
      end
    end

    it "raises NotFoundError for non-existent subject" do
      WebMock.stub_request(:get, /api\.statbank\.dk/).to_return(status: 404, body: 'Not Found')
      _(proc {client.tables(subject: '999')}).must_raise(StatBankDenmark::NotFoundError)
    end
  end

  describe "#table_info" do
    context "when requesting metadata in English" do
      let(:result){client.table_info('STRAF42')}

      it "returns metadata for valid table" do
        VCR.use_cassette("table_info_straf42") do
          _(result).must_be_kind_of(Hash)
          _(result).must_include('id')
          _(result).must_include('text')
          _(result).must_include('variables')
          _(result['id']).must_equal('STRAF42')

          variables = result['variables']
          _(variables).must_be_kind_of(Array)
          _(variables).wont_be_empty
          _(variables.first).must_include('id')
          _(variables.first).must_include('text')
        end
      end
    end

    context "when requesting metadata in Danish" do
      let(:result){client.table_info('STRAF42', lang: 'da')}

      it "returns metadata in Danish" do
        VCR.use_cassette("table_info_straf42_da") do
          _(result).must_be_kind_of(Hash)
          _(result['id']).must_equal('STRAF42')
        end
      end
    end

    it "raises ArgumentError for nil table_id" do
      _(proc{client.table_info(nil)}).must_raise(ArgumentError)
    end

    it "raises ArgumentError for empty table_id" do
      _(proc{client.table_info('')}).must_raise(ArgumentError)
    end

    it "raises NotFoundError for non-existent table" do
      WebMock.stub_request(:get, /api\.statbank\.dk/).to_return(status: 404, body: 'Table not found')
      _(proc{client.table_info('NONEXISTENT')}).must_raise(StatBankDenmark::NotFoundError)
    end
  end

  describe "#data" do
    context "when requesting CSV format" do
      let(:result) do
        client.data(
          'STRAF42',
          format: 'csv',
          variables: {'HERKOMST1' => ['00'], 'TID' => ['2023']}
        )
      end

      it "returns CSV data for table with variables" do
        VCR.use_cassette("data_straf42_csv") do
          _(result).must_be_kind_of(String)
          _(result).must_include('HERKOMST1')
          _(result).must_include('2023')
          _(result.lines.length).must_be(:>, 1)
        end
      end
    end

    context "when requesting JSON format" do
      let(:result) do
        client.data(
          'STRAF42',
          format: 'jsonstat',
          variables: {'HERKOMST1' => ['00'], 'TID' => ['2023']}
        )
      end

      it "returns JSON data for table" do
        VCR.use_cassette("data_straf42_json") do
          _(result).must_be_kind_of(Hash)
          _(result).wont_be_empty
          _(result['dataset']['dimension']).must_include('HERKOMST1')
          _(result['dataset']['dimension']).must_include('ContentsCode')
          _(result['dataset']['dimension']).must_include('Tid')
          _(result['dataset']['dimension']).must_include('id')
          _(result['dataset']['dimension']).must_include('size')
          _(result['dataset']['dimension']).must_include('role')
        end
      end
    end

    context "when no variables specified" do
      let(:result) do
        client.data(
          'STRAF42',
          format: 'jsonstat'
        )
      end

      it "returns all available data" do
        VCR.use_cassette("data_straf42_all") do
          _(result).must_be_kind_of(Hash)
          _(result).wont_be_empty
        end
      end
    end

    it "raises ArgumentError for nil table_id" do
      _(proc{client.data(nil)}).must_raise(ArgumentError)
    end

    it "raises ArgumentError for empty table_id" do
      _(proc{client.data('')}).must_raise(ArgumentError)
    end

    it "raises BadRequestError for invalid variables" do
      WebMock.stub_request(:post, /api\.statbank\.dk/).to_return(status: 400, body: 'Invalid variable specification')
      _(proc{client.data('STRAF42', variables: {'INVALID' => ['bad']})}).must_raise(StatBankDenmark::BadRequestError)
    end

    it "handles rate limiting" do
      WebMock.stub_request(:post, /api\.statbank\.dk/).to_return(status: 429, body: 'Rate limit exceeded')
      _(proc{client.data('STRAF42')}).must_raise(StatBankDenmark::RateLimitError)
    end

    it "handles server errors" do
      WebMock.stub_request(:post, /api\.statbank\.dk/).to_return(status: 500, body: 'Internal Server Error')
      _(proc{client.data('STRAF42')}).must_raise(StatBankDenmark::ServerError)
    end
  end

  describe "#search" do
    context "when searching for existing tables" do
      let(:result){client.search('crime')}

      it "finds tables by search term" do
        VCR.use_cassette("search_crime") do
          _(result).must_be_kind_of Array
          crime_table = result.find{|t| t['id'] == 'STRAF42'}
          _(crime_table).wont_be_nil if crime_table
        end
      end
    end

    context "when searching for non-existent tables" do
      let(:result){client.search('xyzzyx_nonexistent_term')}

      it "returns empty array for no matches" do
        VCR.use_cassette("search_nomatch") do
          _(result).must_be_kind_of(Array)
          _(result).must_be_empty
        end
      end
    end

    context "when testing case sensitivity" do
      let(:result_lower){client.search('population')}
      let(:result_upper){client.search('POPULATION')}

      it "is case insensitive" do
        VCR.use_cassette("search_case_insensitive") do
          _(result_lower).must_equal(result_upper)
        end
      end
    end

    context "when searching in Danish" do
      let(:result){client.search('befolkning', lang: 'da')}

      it "searches in Danish language" do
        VCR.use_cassette("search_danish") do
          _(result).must_be_kind_of(Array)
        end
      end
    end
  end

  describe "error handling" do
    context "when network times out" do
      before do
        WebMock.stub_request(:get, /api\.statbank\.dk/).to_timeout
      end

      it "handles network timeouts" do
        _(proc{client.subjects}).must_raise(StandardError)
      end
    end

    context "when API returns malformed JSON" do
      let(:result){client.subjects}

      before do
        WebMock.stub_request(:get, /api\.statbank\.dk/).to_return(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: 'invalid json{'
        )
      end

      it "handles malformed JSON responses gracefully" do
        _(result).must_equal('invalid json{')
      end
    end
  end

  describe "private methods" do
    it "builds request URLs correctly" do
      url = client.send(:request_string, path: '/subjects')
      _(url).must_equal('https://api.statbank.dk/v1/subjects')
    end

    it "validates HTTP verbs" do
      _(proc{client.send(:do_request, verb: 'PATCH', path: '/test')}).must_raise(ArgumentError)
    end
  end
end

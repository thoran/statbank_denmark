# lib/StatBankDenmark.rb
# StatBankDenmark

require_relative './StatBankDenmark/VERSION'
require_relative './StatBankDenmark/Client'

module StatBankDenmark
  class << self
    def subjects(**options)
      client.subjects(**options)
    end

    def tables(**options)
      client.tables(**options)
    end

    def table_info(table_id, **options)
      client.table_info(table_id, **options)
    end

    def data(table_id, **options)
      client.data(table_id, **options)
    end

    def search(query, **options)
      client.search(query, **options)
    end

    private

    def client
      @client ||= Client.new
    end
  end
end

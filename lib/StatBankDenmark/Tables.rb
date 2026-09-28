# lib/StatBankDenmark/Tables.rb
# StatBankDenmark::Tables

# Six crime and population tables and their dimensions, taken from table_info on
# 20260928.  The values each dimension takes are not here: 1693 of them across
# these six, Tid grows every year, and table_info answers with them already.
#
# Two things worth knowing before choosing a table.  HERKOMST1 in STRAF42 and
# HERKOMST in FOLK1C and FOLK2 are not two spellings of one dimension: the first
# is citizenship and the second residence, so they do not substitute.  And
# STRAFNA3 and VAN66 have no ancestry dimension at all — IELAND, country of
# origin, is the nearest either offers.

module StatBankDenmark
  module Tables
    TABLES = {
      'STRAF42' => {
        name: 'Decisions, total',
        dimensions: {
          'HERKOMST1' => {name: 'national origin', as: :national_origin},
          'OVERTRÆD' => {name: 'type of offence', as: :type_of_offence},
          'AFGØRELSE' => {name: 'type of decision', as: :type_of_decision},
          'ALDER' => {name: 'age', as: :age},
          'KØN' => {name: 'sex', as: :sex},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
      'STRAF10' => {
        name: 'Reported criminal offences',
        dimensions: {
          'OVERTRÆD' => {name: 'type of offence', as: :type_of_offence},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
      'STRAFNA3' => {
        name: 'Persons guilty in crimes',
        dimensions: {
          'KOEN' => {name: 'sex', as: :sex},
          'ALDER' => {name: 'age', as: :age},
          'IELAND' => {name: 'country of origin', as: :country_of_origin},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
      'FOLK1C' => {
        name: 'Population at the first day of the quarter',
        dimensions: {
          'OMRÅDE' => {name: 'region', as: :region},
          'KØN' => {name: 'sex', as: :sex},
          'ALDER' => {name: 'age', as: :age},
          'HERKOMST' => {name: 'ancestry', as: :ancestry},
          'IELAND' => {name: 'country of origin', as: :country_of_origin},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
      'FOLK2' => {
        name: 'Population 1. January',
        dimensions: {
          'ALDER' => {name: 'age', as: :age},
          'KØN' => {name: 'sex', as: :sex},
          'HERKOMST' => {name: 'ancestry', as: :ancestry},
          'STATSB' => {name: 'citizenship', as: :citizenship},
          'IELAND' => {name: 'country of origin', as: :country_of_origin},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
      'VAN66' => {
        name: 'Residence permits (year)',
        dimensions: {
          'STATSB' => {name: 'citizenship', as: :citizenship},
          'OPHOLD' => {name: 'residence permit', as: :residence_permit},
          'Tid' => {name: 'time', as: :time, time: true},
        },
      },
    }

    class << self
      def [](table_id)
        TABLES[table_id.to_s.upcase]
      end

      def ids
        TABLES.keys
      end

      def dimensions(table_id)
        self[table_id]&.fetch(:dimensions, nil)
      end

      # What a dimension is called once the row is read as Ruby.
      def column(table_id, dimension)
        dimensions(table_id)&.dig(dimension.to_s, :as)
      end
    end # class << self
  end
end

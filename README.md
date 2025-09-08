# statbank_denmark

A Ruby client for easy access to StatBank; Denmark's official statistics (Danmarks Statistik) REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statbank_denmark'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install statbank_denmark
```

## Usage

### Defaults for all interfaces
```ruby
lang: 'en' # also can be 'da'
format: 'json' # except for data(), where it defaults to format: 'csv' and JSON data requires format: 'jsonstat'
```

### Via module methods
```ruby
# Get all subjects in English
StatBankDenmark.subjects # implicitly lang: 'en'
StatBankDenmark.subjects(lang: 'en') # explicitly lang: 'en'

# Get all subjects in Danish
StatBankDenmark.subjects(lang: 'da')

# Get subjects recursively
StatBankDenmark.subjects(recursive: true)

# Get a list of all tables
StatBankDenmark.tables

# Get a list of tables about a specific subject by code
StatBankDenmark.tables(subject: 4)

# Get a list of tables which are inactive
StatBankDenmark.tables(include_inactive: true)

# Get a list of tables which are inactive on a specific subject by code
StatBankDenmark.tables(include_inactive: true, subject: 4)

# Get info on a specific table
StatBankDenmark.table_info('STRAF42') # implicitly format: 'json'
StatBankDenmark.table_info('STRAF42', format: 'json') # explicitly format: 'json'
StatBankDenmark.table_info('STRAF42', format: 'csv') # format: 'csv'

# Get data from a specific table
StatBankDenmark.data('STRAF42') # implicitly format: 'csv'
StatBankDenmark.data('STRAF42', format: 'csv') # explicitly format: 'csv'
StatBankDenmark.data('STRAF42', format: 'jsonstat') # Returns json and must be specified with /jsonstat/i, not /json/i.

# Search tables for metadata strings
StatBankDenmark.search('population')
StatBankDenmark.search('POPULATION') # case insensitive search
StatBankDenmark.search('befolkning', lang: 'da') # lang: 'da'
StatBankDenmark.search('BEFOLKNING', lang: 'da') # case insensitive search and lang: 'da'
```

### Via instantiation
```ruby
client = StatBankDenmark.new

# Get all subjects in English
client.subjects # implicitly lang: 'en'
client.subjects(lang: 'en') # explicitly lang: 'en'

# Get all subjects in Danish
client.subjects(lang: 'da')

# Get subjects recursively
client.subjects(recursive: true)

# Get a list of all tables
client.tables

# Get a list of tables about a specific subject by code
client.tables(subject: 4)

# Get a list of tables which are inactive
client.tables(include_inactive: true)

# Get a list of tables which are inactive on a specific subject by code
client.tables(include_inactive: true, subject: 4)

# Get info on a specific table
client.table_info('STRAF42') # implicitly format: 'json'
client.table_info('STRAF42', format: 'json') # explicitly format: 'json'
client.table_info('STRAF42', format: 'csv') # format: 'csv'

# Get data from a specific table
client.data('STRAF42') # implicitly format: 'csv'
client.data('STRAF42', format: 'csv') # explicitly format: 'csv'
client.data('STRAF42', format: 'jsonstat') # Returns json and must be specified with /jsonstat/i, not /json/i.

# Search tables for metadata strings
client.search('population')
client.search('POPULATION') # case insensitive search
client.search('befolkning', lang: 'da') # lang: 'da'
client.search('BEFOLKNING', lang: 'da') # case insensitive search and lang: 'da'
```

## Contributing

1. Fork it (https://github.com/thoran/statbank_denmark/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

## License

The gem is available as open source under the terms of the [Ruby License](https://opensource.org/licenses/MIT).

require_relative './lib/StatBankDenmark/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'statbank_denmark'

  spec.version = StatBankDenmark::VERSION
  spec.date = '2025-09-09'

  spec.summary = "A Ruby client for the StatBank Denmark API."
  spec.description = "A Ruby client for easy access to StatBank; Denmark's official statistics (Danmarks Statistik) REST API."

  spec.authors = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'https://github.com/thoran/statbank_denmark'
  spec.license = 'Ruby'

  spec.required_ruby_version = '>= 2.7'

  spec.files = [
    'CHANGELOG.txt',
    'Gemfile',
    'README.md',
    'statbank_denmark.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb']
  ].flatten
  spec.require_paths = ['lib']

  spec.add_dependency('http.rb')
  spec.add_dependency('json')

  spec.add_development_dependency('minitest')
  spec.add_development_dependency('minitest-spec-context')
  spec.add_development_dependency('webmock')
  spec.add_development_dependency('vcr')
end

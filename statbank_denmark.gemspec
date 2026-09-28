# statbank_denmark.gemspec

require_relative './lib/StatBankDenmark/VERSION'

class Gem::Specification
  def dependencies=(gems)
    gems.each{|gem| add_dependency(*gem)}
  end

  def development_dependencies=(gems)
    gems.each{|gem| add_development_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'statbank_denmark'
  spec.version = StatBankDenmark::VERSION

  spec.summary = "A Ruby client for the StatBank Denmark API."
  spec.description = "A Ruby client for easy access to StatBank; Denmark's official statistics (Danmarks Statistik) REST API."

  spec.authors = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'https://github.com/thoran/statbank_denmark'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7'
  spec.require_paths = ['lib']

  spec.files = [
    'statbank_denmark.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'CHANGELOG',
    'Gemfile',
    'LICENSE',
    'Rakefile',
    'README.md',
  ].flatten

  spec.dependencies = %w{
    http.rb
    json
  }

  spec.development_dependencies = %w{
    rake
    minitest
    minitest-spec-context
    webmock
    vcr
  }
end

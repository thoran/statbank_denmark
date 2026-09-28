# Rakefile

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = false
end

task default: :test

desc "Run tests"
task :spec => :test

# test/integration_test.rb skips itself unless this is set, so it is in the
# default run and costs nothing there.  This task is how it is asked for.
desc "Run the tests which call the live API"
task :integration do
  ENV['RUN_INTEGRATION_TESTS'] = '1'
  Rake::Task[:test].invoke
end

desc "Show version"
task :version do
  require_relative './lib/StatBankDenmark/VERSION'
  puts "statbank_denmark #{StatBankDenmark::VERSION}"
end

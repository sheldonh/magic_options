require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run all rspec examples'
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc 'Run all rspec examples with pretty output'
  RSpec::Core::RakeTask.new(:doc) do |t|
    t.rspec_opts = '--color --format=doc'
  end
end

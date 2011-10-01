require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rdoc/task'

desc 'Generate rdoc documentation'
RDoc::Task.new do |t|
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include %w{ lib/**/*.rb }
end

desc 'Run all rspec examples'
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc 'Run all rspec examples with pretty output'
  RSpec::Core::RakeTask.new(:doc) do |t|
    t.rspec_opts = '--color --format=doc'
  end
end

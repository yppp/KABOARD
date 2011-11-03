require 'rspec/core/rake_task'

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-fs', '-c']
  t.pattern = 'spec/**/*_spec.rb'
end

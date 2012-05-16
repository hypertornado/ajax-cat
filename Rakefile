# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "ajax-cat"
  gem.homepage = "http://github.com/hypertornado/ajax-cat"
  gem.license = "MIT"
  gem.summary = %Q{computer-aided translation backed by machine translation}
  gem.description = %Q{computer-aided translation backed by machine translation}
  gem.email = "odchazel@gmail.com"
  gem.authors = ["Ondrej Odchazel"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:unit) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList['test/unit/test_*.rb','test/integration/*.rb']
    test.verbose = false
  end
  Rake::TestTask.new(:integration) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList['test/integration/*.rb']
    test.verbose = false
  end
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ajax-cat #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

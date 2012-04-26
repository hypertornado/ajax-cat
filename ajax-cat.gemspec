# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ajax-cat"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ondrej Odchazel"]
  s.date = "2012-04-26"
  s.description = "computer-aided translation backed by machine translation"
  s.email = "odchazel@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "ajax-cat.gemspec",
    "lib/.DS_Store",
    "lib/ajax-cat.rb",
    "lib/public/AjaxCatList.coffee",
    "lib/public/AjaxCatTranslation.coffee",
    "lib/public/Suggestions.coffee",
    "lib/public/TranslationTable.coffee",
    "lib/public/Utils.coffee",
    "lib/public/ajax-cat.coffee",
    "lib/public/ajax-cat.js",
    "lib/public/bootstrap.css",
    "lib/public/bootstrap.js",
    "lib/public/index.html",
    "lib/public/index.js",
    "lib/public/jquery.js",
    "lib/public/style.css",
    "lib/public/translation.html",
    "lib/public/translation.js",
    "test/helper.rb",
    "test/test_ajax-cat.rb"
  ]
  s.homepage = "http://github.com/hypertornado/ajax-cat"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "computer-aided translation backed by machine translation"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end


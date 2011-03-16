# coding: utf-8

require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "komando"
    gem.summary = %Q{Command-driven framework, especially suited for web applications}
    gem.description = %Q{Most web applications have a lot of before/after hooks that occur when working with objects: sending a welcome email on registration, incrementing/decrementing counter caches, trigger validation on remote web services. When implemented using callbacks, all these occur without the developer knowing about them. A simple change in one area of the code can have a huge impact somewhere else. Inspiration for this came from http://blog.teksol.info/2010/09/28/unintented-consequences-the-pitfalls-of-activerecord-callbacks.html and http://jamesgolick.com/2010/3/14/crazy-heretical-and-awesome-the-way-i-write-rails-apps.html}
    gem.email = "francois@teksol.info"
    gem.homepage = "http://github.com/francois/komando"
    gem.authors = ["François Beausoleil"]

    # Don't bundle development code with the gem
    gem.files -= FileList["samples/**/*"]

    gem.add_development_dependency "bacon", ">= 0"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "bluecloth", ">= 0"
    # BlueCloth is "required" by yard, where it is used to format the docs, but is not really a required dependency.
    # Use 1.9.2 to generate the docs.

    gem.add_development_dependency "activerecord", "~> 2.3.8"
    gem.add_development_dependency "jeweler", "~> 1.4.0"

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |spec|
    spec.libs << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

RUBIES = %w(
  1.9.2@komando
  1.8.7@komando
  ree@komando
  jruby@komando
)

def rvm(command)
  sh "rvm #{RUBIES.join(",")} exec #{command}"
end

namespace :rubies do
  namespace :bundle do
    task :install do
      rvm "gem install bundler"
      rvm "bundle install"
    end
  end

  task :version do
    rvm "ruby --version"
  end

  task :spec do
    rvm "rake spec"
  end

  task :default do
    sh "rvm use #{RUBIES.first}"
  end

  namespace :gemset do
    task :create do
      RUBIES.each do |ruby|
        sh "rvm use #{ruby} && rvm --force gemset create komando"
      end
    end

    task :delete do
      RUBIES.each do |ruby|
        sh "rvm use #{ruby} && rvm --force gemset delete"
      end
    end
  end
end

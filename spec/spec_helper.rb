require 'rubygems'
require 'bacon'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'komando'
require "komando/command"
require "komando/command/dsl"

print "\n\n#{RUBY_PLATFORM} -- #{RUBY_VERSION} -- #{RUBY_RELEASE_DATE}"
print "-- JRuby Detected" if Object.const_defined?("JRUBY_VERSION")
print "\n\n"

Bacon.summary_on_exit

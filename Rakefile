require "./squeak"
require "sinatra/activerecord/rake"

begin
	require 'vlad'
	Vlad.load :scm => 'git'
rescue LoadError
	# Meh
end

task "vlad:deploy" => %w[ vlad:update vlad:bundle:install ]
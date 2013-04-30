require 'bundler/setup'
require 'sinatra'
require 'haml'

#require_relative 'models/init'

get '/' do
  haml :index
end


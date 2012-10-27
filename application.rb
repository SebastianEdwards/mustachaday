#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'redis'

get '/' do
  haml :index
end

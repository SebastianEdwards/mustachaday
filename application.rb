#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require './lib/gififier'

get '/' do
  haml :index
end

post '/gif' do
  gififier = GIFifier.new(params[:images], File.join('public', 'gif'))
  gififier.generate!

  redirect to('/gif/' + gififier.filename)
end

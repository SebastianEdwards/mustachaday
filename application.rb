#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require './lib/gififier'
require './lib/gif_store'

GIF_STORE = GIFStore.new(ENV['S3_KEY'], ENV['S3_SECRET'], ENV['S3_BUCKET'])

get '/' do
  haml :index
end

post '/gif' do
  gififier = GIFifier.new(params[:images], GIF_STORE)
  gififier.generate!

  redirect to gififier.url
end

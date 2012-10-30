#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require './lib/gififier'
require './lib/gif_store'

GIF_STORE = GIFStore.new(ENV['S3_KEY'], ENV['S3_SECRET'], ENV['S3_BUCKET'])

get '/' do
  haml :index
end

post '/gif' do
  gififier = GIFifier.new(params[:images], GIF_STORE).generate!

  if @env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    content_type 'application/json'
    {gif: gififier.url}.to_json
  else
    redirect to(gififier.url)
  end
end

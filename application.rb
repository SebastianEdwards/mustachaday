#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require './lib/gififier'
require './lib/s3_store'
require './lib/local_store'

if ENV['RUBY_ENV'] == 'development'
  GIF_STORE = LocalStore.new(File.join('public', 'gif'), 'gif')
else
  GIF_STORE = S3Store.new(ENV['S3_KEY'], ENV['S3_SECRET'], ENV['S3_BUCKET'])
end

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

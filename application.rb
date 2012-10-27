#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'redis'

def redis
  redis ||= Redis.new
end

get '/' do
  redis.set 'foo', 'bar'

  redis.get 'foo'
end

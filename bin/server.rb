#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'redis'
require 'term/ansicolor'

redis = Redis.new

get '/' do
  @test_runs = redis.keys.sort
  erb :index
end

get '/:test' do

  # Sanitize :test here
  
  @test = params[:test]
  @suites = redis.hgetall(@test)
  erb :test

end

get '/:test/:suite' do

  # Sanitize :test and :suite here
  
  @test = params[:test]
  @suite = params[:suite]
  @details = JSON.parse(redis.hget(@test, @suite))
  erb :suite

end


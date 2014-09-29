#!/usr/bin/env ruby

require 'thread/pool'
require 'json'
require 'redis'

test_time = Time.now
test_name = "#{File.basename(Dir.getwd)}-#{test_time.year}-#{test_time.month}-#{test_time.day}-#{test_time.hour}-#{test_time.min}"
list_output = `kitchen list -b`

pool = Thread.pool(20)
redis = Redis.new

list_output.each_line do |suite_name|

  pool.process do

    log = {start: Time.now}
    puts "[#{log[:start]}] Starting #{suite_name}"
    redis.hset(test_name, suite_name, log.to_json)
    log[:output] = `kitchen test #{suite_name}`
    log[:exitstatus] = $?.exitstatus
    log[:ended] = Time.now
    redis.hset(test_name, suite_name, log.to_json)
    puts "[#{log[:ended]}] Finished #{suite_name}"

  end

end

pool.shutdown

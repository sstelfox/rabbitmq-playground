
require 'bunny'
require 'json'
require 'securerandom'

connection = Bunny.new(ENV['AMQP_URI'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.channel
exchange = channel.direct('pwnie.cloud', :durable => true)
queue = channel.queue("noop", :auto_delete => true).bind(exchange, :routing_key => 'test.workers')

loop {
  puts queue.status
  sleep 1
}

connection.close


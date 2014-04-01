
require 'bunny'
require 'json'
require 'securerandom'

connection = Bunny.new(ENV['AMQP_URI'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.channel
exchange = channel.topic('pwnie.cloud')
queue = channel.queue("workers.test").bind(exchange, :routing_key => "workers.test.#")
queue.purge

connection.close


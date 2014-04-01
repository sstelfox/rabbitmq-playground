
require 'bunny'

connection = Bunny.new(ENV['AMQP_URL'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.create_channel
exchange = channel.default_exchange

queue = channel.queue('bunny.example.hello_world', :auto_delete => true)

exchange.publish('Hello!', :routing_key => queue.name)
exchange.publish('Hello!', :routing_key => queue.name)
exchange.publish('Hello!', :routing_key => queue.name)
exchange.publish('Hello!', :routing_key => queue.name)

connection.close

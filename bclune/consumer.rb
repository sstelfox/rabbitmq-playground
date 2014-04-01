
require 'bunny'

connection = Bunny.new(ENV['AMQP_URL'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.create_channel

queue = channel.queue('bunny.example.hello_world', :auto_delete => true)

queue.subscribe do |delivery_info, message, payload|
  puts "Received #{payload}"
end

sleep 400

connection.close


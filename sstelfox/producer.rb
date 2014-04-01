
require 'bunny'

connection = Bunny.new(ENV['AMQP_URL'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.channel
exchange = channel.direct('test.workers')

def message_generator(size)

end



require 'bunny'

connection = Bunny.new(ENV['AMQP_URL'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start


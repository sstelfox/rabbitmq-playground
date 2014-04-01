
require 'bunny'
require 'json'
require 'securerandom'

connection = Bunny.new(ENV['AMQP_URI'] || "amqp://guest:guest@127.0.0.1:5672")
connection.start

channel = connection.channel
exchange = channel.topic('pwnie.cloud')
queue = channel.queue("workers.test").bind(exchange, :routing_key => "workers.test.#")

def message_generator(byte_size)
  JSON.generate({size: byte_size, time: Time.now.to_f, content: SecureRandom.hex(byte_size / 2)})
end

stats = {}
stats[:start_time] = Time.now.to_f
stats[:duration] = 5
stats[:message_size] = 256
stats[:counts] = Hash.new(0)

while Time.now.to_f < (stats[:start_time] + stats[:duration])
  exchange.publish(message_generator(stats[:message_size]), :routing_key => 'workers.test.something')
  stats[:counts][Time.now.to_i] += 1
end

stats[:end_time] = Time.now.to_f

stats[:total_time] = stats[:end_time] - stats[:start_time]
stats[:total_messages] = msgs_generated = stats[:counts].values.inject(&:+)

generation_start_time = Time.now.to_f
msgs_generated.times { message_generator(stats[:message_size]) }
generation_end_time = Time.now.to_f

stats[:message_generation_time] = generation_end_time - generation_start_time

empty_start_time = Time.now.to_f
while queue.status[:message_count] > 0
  queue.pop
end
empty_end_time = Time.now.to_f

stats[:empty_time] = empty_end_time - empty_start_time

puts JSON.pretty_generate(stats)

connection.close


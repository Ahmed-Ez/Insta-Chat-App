require 'bunny'
class Sender
    def self.push(message)
        connection = Bunny.new
        connection.start
        channel = connection.create_channel
        queue = channel.queue("test")
        channel.default_exchange.publish(message, routing_key: queue.name)
        connection.close
    end
end
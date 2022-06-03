require 'bunny'
class Sender
    def self.push(queue_name,message)
        connection = Bunny.new(hostname:ENV['MQ_HOST'])
        connection.start
        channel = connection.create_channel
        queue = channel.queue(queue_name,durable: true)
        queue.publish(message,persistent: true)
        connection.close
    end
end
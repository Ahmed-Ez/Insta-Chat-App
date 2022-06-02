require 'bunny'

class Consumer

  def self.run_consumer
    connection = Bunny.new(hostname:ENV['MQ_HOST'])
    connection.start

    channel = connection.create_channel
    queue = channel.queue('test',durable: true)

    channel.prefetch(1)
    begin
        queue.subscribe(manual_ack: true,block: false) do |_delivery_info, _properties, body|
        channel.ack(_delivery_info.delivery_tag)
        end
      rescue
        connection.close
      end
  end
end

require 'bunny'

class Consumer

  def self.run_consumer
    connection = Bunny.new
    connection.start

    channel = connection.create_channel
    queue = channel.queue('test')
    begin
        queue.subscribe(block: false) do |_delivery_info, _properties, body|
        end
      rescue
        connection.close
      end
  end
end

require 'bunny'

class Consumer

  
  def initialize

    @connection = Bunny.new(hostname:ENV['MQ_HOST'])
    @connection.start

    @channel = @connection.create_channel
  end

  def run_apps_consumer
    
    queue = @channel.queue(ENV['APPS_MQ_NAME'],durable: true)

    @channel.prefetch(1)
    begin
        queue.subscribe(manual_ack: true,block: false) do |_delivery_info, _properties, body|
        @channel.ack(_delivery_info.delivery_tag)

        json_data = JSON.parse(body)
        app = App.find_by(token:json_data["token"])
        if app != nil
        app.update(name:json_data["name"])
        else
        app = App.new(json_data)
        app.save()
        end
        end
      rescue
        @connection.close
      end
  end

  def run_chats_consumer
    
    queue = @channel.queue(ENV['CHATS_MQ_NAME'],durable: true)

    @channel.prefetch(1)
    begin
        queue.subscribe(manual_ack: true,block: false) do |_delivery_info, _properties, body|
        @channel.ack(_delivery_info.delivery_tag)
        json_data = JSON.parse(body)
        chat = Chat.where(app_id:json_data["app_id"],number:json_data["number"]).first
        if chat != nil 
          chat.update(name:json_data["name"])
        else
          chat = Chat.new(json_data)
          chat.save()
          app = App.find_by(id:json_data["app_id"])
          app.increment(:chats_count,1)
          app.save()
        end
      end
      rescue
        @connection.close
      end
  end

  def run_messages_consumer
    
    queue = @channel.queue(ENV['MESSAGES_MQ_NAME'],durable: true)

    @channel.prefetch(1)
    begin
        queue.subscribe(manual_ack: true,block: false) do |_delivery_info, _properties, body|
          @channel.ack(_delivery_info.delivery_tag)
          json_data = JSON.parse(body)
          puts json_data
          message = Message.where(chat_id:json_data["chat_id"],number:json_data["number"]).first
          if message != nil
            message.update(content:json_data["content"])
          else
            message = Message.new(json_data)
            chat = Chat.find_by(id:json_data["chat_id"])
            chat.increment(:messages_count,1)
            chat.save()
            message.save()
          end
        end
      rescue
        @connection.close
      end
  end
end

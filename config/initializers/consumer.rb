require 'consumer'

mq_consumer = Consumer.new()

mq_consumer.run_apps_consumer

mq_consumer.run_chats_consumer

mq_consumer.run_messages_consumer
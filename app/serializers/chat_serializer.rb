class ChatSerializer < ActiveModel::Serializer
  attributes :number,:name, :created_at, :updated_at, :messages_count
end

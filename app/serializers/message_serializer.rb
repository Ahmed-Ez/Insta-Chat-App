class MessageSerializer < ActiveModel::Serializer
    attributes :content, :number,:created_at,:updated_at
  end
  
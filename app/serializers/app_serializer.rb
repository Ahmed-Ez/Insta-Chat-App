class AppSerializer < ActiveModel::Serializer
  attributes :name, :token,:created_at,:chats_count
end

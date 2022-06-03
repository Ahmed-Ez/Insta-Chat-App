class App < ApplicationRecord
    has_many :chats,dependent: :destroy
    validates :name, presence: true, length: {minimum:3}
end

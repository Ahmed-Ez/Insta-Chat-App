class Chat < ApplicationRecord
    belongs_to :app
    has_many :messages, dependent: :destroy
    validates :name, presence: true, length: {minimum:3}
end

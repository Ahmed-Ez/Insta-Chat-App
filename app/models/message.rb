class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    belongs_to :chat
    validates :content, presence: true, length: {minimum:1}

end

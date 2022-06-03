class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :number
      t.timestamps
      t.belongs_to :chat, foreign_key: true
    end
  end
end

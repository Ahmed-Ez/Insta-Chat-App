class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :name
      t.integer :number
      t.integer :messages_count, :default => 0
      t.timestamps
      t.belongs_to :app, foreign_key: true

    end
  end
end

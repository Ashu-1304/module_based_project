class CreateBxBlockNotificationsNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.references :account, foreign_key: true
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end

class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :endpoint, null: false, index: true
      t.string :p256dh
      t.string :auth
      t.timestamp :expiration_time

      t.timestamps
    end
  end
end

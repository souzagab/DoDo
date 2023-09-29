class AddUserToTasks < ActiveRecord::Migration[7.1]
  def change
    change_table :tasks do |t|
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end

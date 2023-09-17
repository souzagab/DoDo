class CreateTasks < ActiveRecord::Migration[7.1]
  def up
    create_enum :task_status, %w[draft open closed archived]

    create_table :tasks do |t|
      t.string :body, null: false, index: true
      t.enum :status, enum_type: :task_status, default: "open", null: false, index: true
      t.datetime :due_date, index: true

      t.timestamps
    end
  end

  def down
    drop_table :tasks
    drop_enum :task_status
  end
end

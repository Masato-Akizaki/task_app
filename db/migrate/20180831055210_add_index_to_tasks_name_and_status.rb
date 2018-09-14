class AddIndexToTasksNameAndStatus < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, [:user_id, :name, :created_at]
    add_index :tasks, [:user_id, :status, :created_at]
  end
end

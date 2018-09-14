class ChangeDatatypeStatusAndPriorityOfTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :status, 'integer USING CAST(status AS integer)'
    change_column :tasks, :priority, 'integer USING CAST(priority AS integer)'
  end
end

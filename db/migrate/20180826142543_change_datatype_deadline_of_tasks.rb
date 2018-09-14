class ChangeDatatypeDeadlineOfTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :deadline, :date
  end
end

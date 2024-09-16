class AddInProgressToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :in_progress, :boolean
  end
end

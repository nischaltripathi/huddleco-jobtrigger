class AddIntercomInboxToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :intercom_inbox, :string
  end
end

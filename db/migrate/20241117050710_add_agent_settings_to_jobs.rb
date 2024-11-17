class AddAgentSettingsToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :intercom_admin, :string
    add_column :jobs, :default_teammate, :integer
    add_column :jobs, :agent_mappings, :jsonb, default: {}, null: false
  end
end

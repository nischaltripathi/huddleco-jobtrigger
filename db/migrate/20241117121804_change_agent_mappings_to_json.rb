class ChangeAgentMappingsToJson < ActiveRecord::Migration[8.0]
  def change
    change_column :jobs, :agent_mappings, :json, using: 'agent_mappings::json'
  end
end

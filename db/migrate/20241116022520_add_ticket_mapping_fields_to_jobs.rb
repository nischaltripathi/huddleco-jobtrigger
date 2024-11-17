class AddTicketMappingFieldsToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :empty_or_default_values, :string
    add_column :jobs, :open_values, :string
    add_column :jobs, :pending_values, :string
    add_column :jobs, :solved_values, :string
    add_column :jobs, :closed_values, :string
    add_column :jobs, :new_values, :string
    add_column :jobs, :import_as_support_requests, :boolean
    add_column :jobs, :support_request_type, :string
  end
end

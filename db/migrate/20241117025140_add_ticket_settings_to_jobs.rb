class AddTicketSettingsToJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :jobs, :migrate_newest_records, :boolean, default: false
    add_column :jobs, :migrate_side_conversations, :boolean, default: false
    add_column :jobs, :demo_customer_data, :boolean, default: false
    add_column :jobs, :skip_attachments, :boolean, default: false
    add_column :jobs, :add_new_tag_to_tickets, :boolean, default: false
    add_column :jobs, :tag_name, :string
  end
end

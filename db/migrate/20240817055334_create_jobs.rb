class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :company_name
      t.string :zendesk_subdomain
      t.string :zendesk_username
      t.string :zendesk_api_key
      t.string :intercom_api_key
      t.decimal :progress, default: 0.0, precision: 10, scale: 2
      t.timestamps
    end
  end
end

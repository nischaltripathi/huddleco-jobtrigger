json.extract! job, :id, :company_name, :string, :zendesk_subdomain, :string, :zendesk_username, :string, :zendesk_api_key, :string, :intercom_api_key, :string, :created_at, :updated_at
json.url job_url(job, format: :json)

class JobsController < ApplicationController
  before_action :set_job, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[edit update destroy]

  DropdownItem = Struct.new(:id, :name)

  def index
    if params[:search_by_job_id].present?
      job = Job.find_by(id: params[:search_by_job_id])
      if job
        redirect_to job_path(job)
      else
        flash[:alert] = "Job with ID #{params[:search_by_job_id]} not found."
        @jobs = Job.all
      end
    else
      @jobs = Job.all
    end
    return unless @jobs.present?

    @jobs.each do |job|
      job.progress = if job.in_progress
                       job.progress + 1
                     else
                       job.progress = job.progress
                     end
      job.save
    end
  end

  def search
    return unless params[:search_by_job_id] && params[:search_by_job_id] != ''

    @jobs = @jobs.where('search_by_job_id like ?',
                        '%# {params[:id]}%')
  end

  def start
    @job = Job.find(params[:id])
    @job.start
    respond_to do |format|
      format.html { redirect_to jobs_path, notice: 'Job started.' }
      format.js
    end
  end

  def correct_user
    @job = current_user.jobs.find_by(id: params[:id])
    redirect_to jobs_path, notice: 'Not Authorized' if @job.nil?
  end

  def pause
    @job = Job.find(params[:id])
    @job.pause
    respond_to do |format|
      format.html { redirect_to jobs_path, notice: 'Job paused.' }
      format.js
    end
  end

  def show; end

  def new
    @job = current_user.jobs.build

    # Example data for dropdowns
    @intercom_admins = [
      DropdownItem.new(id: 1, name: 'info@customersuccess.com'),
      DropdownItem.new(id: 2, name: 'test@customersuccess.com')
    ]
    @default_teammates = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Backup Teammate')
    ]
    @zendesk_agents = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Cristofer Kenter'),
      DropdownItem.new(id: 3, name: 'Kierra Workman'),
      DropdownItem.new(id: 4, name: 'Ashlynn Gouse')
    ]
    @intercom_teammates = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Admin 1'),
      DropdownItem.new(id: 3, name: 'Admin 2')
    ]
  end

  def edit
    # Example data for dropdowns
    @intercom_admins = [
      DropdownItem.new(id: 1, name: 'info@customersuccess.com'),
      DropdownItem.new(id: 2, name: 'test@customersuccess.com')
    ]
    @default_teammates = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Backup Teammate')
    ]
    @zendesk_agents = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Cristofer Kenter'),
      DropdownItem.new(id: 3, name: 'Kierra Workman'),
      DropdownItem.new(id: 4, name: 'Ashlynn Gouse')
    ]
    @intercom_teammates = [
      DropdownItem.new(id: 1, name: 'Gustavo Vetrovs'),
      DropdownItem.new(id: 2, name: 'Admin 1'),
      DropdownItem.new(id: 3, name: 'Admin 2')
    ]
  end

  def create
    @job = current_user.jobs.build(job_params)
    respond_to do |format|
      if @job.save
        format.html { redirect_to job_url(@job), notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to job_url(@job), notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy!

    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :company_name, :zendesk_subdomain, :zendesk_username, :zendesk_api_key,
      :intercom_api_key, :intercom_inbox, :empty_or_default_values, :open_values,
      :pending_values, :solved_values, :closed_values, :new_values,
      :import_as_support_requests, :support_request_type, :migrate_newest_records,
      :migrate_side_conversations, :demo_customer_data, :skip_attachments,
      :add_new_tag_to_tickets, :tag_name, :intercom_admin, :default_teammate,
      agent_mappings: {}
    )
  end
end

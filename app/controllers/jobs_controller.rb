class JobsController < ApplicationController
  before_action :set_job, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[edit update destroy]
  # GET /jobs or /jobs.json
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

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = current_user.jobs.build
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
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

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(:company_name, :zendesk_subdomain, :zendesk_username,
                                :zendesk_api_key, :intercom_api_key)
  end
end

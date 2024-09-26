class Job < ApplicationRecord
  belongs_to :user
  def start
    update(in_progress: true)
  end

  def pause
    update(in_progress: false)
  end
end

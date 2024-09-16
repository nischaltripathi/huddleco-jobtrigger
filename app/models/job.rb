class Job < ApplicationRecord
  def start
    update(in_progress: true)
  end

  def pause
    update(in_progress: false)
  end
end

class MeetingsController < ApplicationController

  def index
    @grouped_meetings = current_user.meetings.where("starts_at <= ?", current_user.from_time).to_a.group_by_day(&:starts_at)
  end

  def show
  end
end

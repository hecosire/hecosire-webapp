class StatusController < ApplicationController
  def index
    users = User.includes(:last_record => :health_state ).all
    records = users.map { |u| u.last_record }.compact
    @states_count_now = stats_for_last(records, 180)

  end

  private

  def stats_for_last(records, last_days_count)
    recent_records = records.select { |r| r.created_at > last_days_count.days.ago }
    states = recent_records.map { |r| r. health_state_id}
    states_count = Hash.new(0)
    states.each do |s|
      states_count[s]+=1
    end
    states_count
  end

end

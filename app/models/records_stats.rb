class RecordsStats

  HEALTHY_ID = 1
  COMING_DOWN_ID = 2
  SICK_ID = 3
  RECOVERING_ID = 4

  def initialize(records)
    @records = records
    @stats = {}
  end

  def stats(days_back=7)
    return @stats[days_back] if @stats[days_back]
    @stats[days_back] = {
        healthy: records_for(HEALTHY_ID, days_back).count,
        coming_down: records_for(COMING_DOWN_ID, days_back).count,
        sick: records_for(SICK_ID, days_back).count,
        recovering: records_for(RECOVERING_ID, days_back).count,
    }
    @stats[days_back]
  end

  def dates_for_timechart(days_back=7)
    records_days_back(days_back).map {|r| "'#{r.created_at.strftime("%Y-%m-%d %H:%M")}'"}.join(',')
  end

  def states_for_timechart(days_back=7)
    records_days_back(days_back).map {|r| "'#{map_health_state_id_for_view(r.health_state_id)}'"}.join(',')
  end

  private

  def records_days_back(days_back)
    @records.select{|r|r.created_at > days_back.days.ago }
  end

  def records_for(state_id, days_back)
    records_days_back(days_back).select{|r| r.health_state_id == state_id}
  end

  def map_health_state_id_for_view(id)
    {
        HEALTHY_ID => 4,
        COMING_DOWN_ID => 2,
        SICK_ID => 1,
        RECOVERING_ID => 3,

    }[id]
  end

end
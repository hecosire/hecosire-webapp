class RecordsStats

  HEALTHY_ID = 1
  COMING_DOWN_ID = 2
  SICK_ID = 3
  RECOVERING_ID = 4

  def initialize(records)
    @records = records
  end

  def stats
    @stats ||=  {
        healthy: records_for(HEALTHY_ID).count,
        coming_down: records_for(COMING_DOWN_ID).count,
        sick: records_for(SICK_ID).count,
        recovering: records_for(RECOVERING_ID).count,
    }
  end

  def dates_for_timechart
    @records.map {|r| "'#{r.created_at.strftime("%Y-%m-%d %H:%M")}'"}.join(',')
  end

  def states_for_timechart
    @records.map {|r| "'#{map_health_state_id_for_view(r.health_state_id)}'"}.join(',')
  end

  private

  def records_for(state_id)
    @records.select{|r| r.health_state_id == state_id}
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
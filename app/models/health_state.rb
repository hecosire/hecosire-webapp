class HealthState < ActiveRecord::Base

  HEALTHY=1
  COMING_DOWN=2
  SICK=3
  RECOVERING=4

  def to_s
    name
  end

end

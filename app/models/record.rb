class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :health_state

  include ActionView::Helpers::JavaScriptHelper

  def self.health_state_by_hour(current_user)
    offset = Time.now.gmt_offset/60/60
    query = "select mod(CAST (date_part('hour', created_at)+(#{offset}) AS NUMERIC), 24) as hour, health_state_id, count(*) from records where user_id  = #{current_user.id} group by hour, health_state_id order by hour;"
    result = ActiveRecord::Base.connection.execute(query)
    healthy = [0] * 24
    coming_down = [0] * 24
    recovering = [0] * 24
    sick = [0] * 24
    result.each do |row|
      state = case row["health_state_id"]
                when "1"
                  healthy
                when "2"
                  coming_down
                when "3"
                  sick
                when "4"
                  recovering
                else
                  raise "unexpected health state id"
              end
      state[row["hour"].to_i] = row["count"].to_i
    end
    morning_length = 11
    middle_length = 6
    second_half_start = morning_length + middle_length
    {
        first_half: {
            healthy: healthy.take(morning_length).reduce(&:+),
            coming_down: coming_down.take(morning_length).reduce(&:+),
            sick: sick.take(morning_length).reduce(&:+),
            recovering: recovering.take(morning_length).reduce(&:+)

        },

        middle_of_day: {
            healthy: healthy.drop(morning_length).take(middle_length).reduce(&:+),
            coming_down: coming_down.drop(morning_length).take(middle_length).reduce(&:+),
            sick: sick.drop(morning_length).take(middle_length).reduce(&:+),
            recovering: recovering.drop(morning_length).take(middle_length).reduce(&:+)

        },

        second_half: {
            healthy: healthy.drop(second_half_start).reduce(&:+),
            coming_down: coming_down.drop(second_half_start).reduce(&:+),
            sick: sick.drop(second_half_start).reduce(&:+),
            recovering: recovering.drop(second_half_start).reduce(&:+)
        },

        per_hour: {
          healthy: healthy,
          coming_down: coming_down,
          sick: sick,
          recovering: recovering
        }
    }
  end

  def safe_comment
     escape_javascript Rack::Utils.escape_html comment
  end

end

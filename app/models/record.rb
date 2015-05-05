class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :health_state

  include ActionView::Helpers::JavaScriptHelper

  def self.wordcloud(current_user, health_state_id=nil)
    record_query = Record.where(user_id: current_user)
    record_query = record_query.where(health_state_id: health_state_id) if health_state_id
    comments = record_query.pluck(:comment).compact
    words = comments.map{ |c| c.split(" ")}.flatten
    @wordcloud = Hash.new(0)
    words.each { |word| @wordcloud[word] += 1 }
    #@wordcloud.reject!{ |k,v| v == 1 }
    @wordcloud.reject!{ |k,v| k.size < 3 }
    @wordcloud
  end

  def self.health_state_by_hour(current_user)
    time1 = Time.zone.now.in_time_zone("UTC")
    time2 = Time.zone.now.in_time_zone(current_user.time_zone)
    time_difference_in_seconds = time2.utc_offset - time1.utc_offset
    diff_in_hours =  (time_difference_in_seconds/60/60).abs

    query = "select date_part('hour', created_at) as hour, health_state_id, count(*) from records where user_id  = #{current_user.id} group by hour, health_state_id order by hour;"
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
      state[(row["hour"].to_i+diff_in_hours)%24] = row["count"].to_i
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

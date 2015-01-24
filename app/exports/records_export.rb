class RecordsExport
  QUERY = <<-SQL
    SELECT
      to_char((records.created_at AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH:mm')               AS "Date created",
      records.health_state_id                                                      AS "Health state id",
      records.comment AS "Comment"
    FROM records

    WHERE
      records.user_id = ?
    ORDER BY records.created_at DESC
  SQL

  def initialize(user)
    @user = user
  end

  def generate
    Export.query_to_csv(Export.send(:sanitize_sql, [QUERY, @user.id]))
  end
end

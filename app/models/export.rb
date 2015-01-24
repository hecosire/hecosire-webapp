class Export < ActiveRecord::Base
  def self.query_to_csv(query)
    copy_query = """
      COPY (#{query}) TO STDOUT (format csv, delimiter ',', header true, null '')
    """

    result = ''

    connection = Export.connection
    connection.raw_connection.copy_data(copy_query) do
      while (line = connection.raw_connection.get_copy_data).present? do
        result << line
      end
    end

    result
  end
end
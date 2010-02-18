# ActiveRecord::ConnectionAdapters::JdbcAdapter always fetches inserted ids
# after executing an insert statement through connection.execute() . this
# is a problem when millions of rows are inserted

# define a base method so we don't need to care about whether
# we are actually using jdbc or not
class ActiveRecord::ConnectionAdapters::AbstractAdapter
  def execute_raw(sql, name = nil)
    execute(sql, name)
  end
end

# then override the base method on the JdbcAdapter
class ActiveRecord::ConnectionAdapters::JdbcAdapter
  def execute_raw(sql, name = nil)
    log(sql, name) do
      if ActiveRecord::ConnectionAdapters::JdbcConnection::select?(sql)
        @connection.execute_query(sql)
      else
        @connection.execute_update(sql)
      end
    end
  end
end

# ActiveRecord::ConnectionAdapters::JdbcAdapter always fetches inserted ids
# after executing an insert statement through connection.execute() . this
# is a problem when millions of rows are inserted

# define a base method so we don't need to care about whether
# we are actually using jdbc or not
module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def execute_raw(sql, name = nil)
        execute(sql, name)
      end
    end

    # then override the base method on the JdbcAdapter
    class JdbcAdapter < AbstractAdapter
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
  end
end

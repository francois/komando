require "komando"
require "active_record"

module Komando
  module Persistence
    # Wraps command executions within a database transaction.
    module ActiveRecord

      # Insinuates this module within {Komando::Command}.
      #
      # @private
      def self.included(base)
        base.send :alias_method_chain, :run!, :transaction
      end

      # Wraps a command execution within a database transactions.
      # This method delegates actual transaction semantics to {#wrap_transaction}.
      # This method is renamed as {Komando::Command##run!} during inclusion.
      def run_with_transaction!
        wrap_transaction do
          run_without_transaction!
        end
      end

      # Does the actual work of wrapping in a transaction. The default is to wrap
      # using {ActiveRecord::Base#transaction}.
      #
      # @example Wrapping using a specific connection
      #   # config/database.yml
      #   development:
      #     adapter: sqlite3
      #     database: db/development.sqlite3
      #
      #   require "komando/persistence/active_record"
      #
      #   class User < ActiveRecord::Base
      #     establish_connection :adapter => "sqlite3", :database => "/var/dbs/users.sqlite3"
      #   end
      #
      #   class CreateUserCommand
      #     include Komando::Command
      #     include Komando::Persistence::ActiveRecord
      #
      #     def wrap_transaction
      #       User.transaction do
      #         yield
      #       end
      #     end
      #   end
      #
      # @yieldreturn The block's last value.
      def wrap_transaction
        ::ActiveRecord::Base.transaction do
          yield
        end
      end

      # Uses the same Logger instance as ActiveRecord.
      def logger
        ::ActiveRecord::Base.logger
      end

    end
  end
end

require "komando"
require "active_record"

module Komando
  module Persistence
    module ActiveRecord

      def self.included(base)
        base.send :alias_method_chain, :run!, :transaction
      end

      def run_with_transaction!
        wrap_transaction do
          run_without_transaction!
        end
      end

      def wrap_transaction
        ::ActiveRecord::Base.transaction do
          yield
        end
      end

    end
  end
end

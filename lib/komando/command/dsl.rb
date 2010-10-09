module Komando
  module Command

    # The Komando DSL. Extend your command classes with this module to start using
    # Komando in your application.
    #
    # It is recommended you do not implement #initialize in your commands. If you do,
    # you *must* call super or your parameters will not be available as instance variables.
    #
    # @example
    #
    #   require "komando/command/dsl"
    #
    #   class CreateUserCommand
    #     extend Komando::Command::Dsl
    #
    #     def initialize(*args)
    #       super # MUST call, or all hell will break loose
    #     end
    #
    #     mandatory_steps do
    #       generate_records
    #       generate_audit_log
    #     end
    #
    #     private
    #
    #     def generate_records
    #       # TODO
    #     end
    #
    #     def generate_audit_log
    #       # TODO
    #     end
    #   end
    module Dsl

      # Declares a set of actions that must run to completion for this command to be deemed successful.
      # The declared actions may be anything: method calls or direct actions. Parameters are passed from the
      # environment as instance variables passed to the instance.
      #
      # @raise [MultipleMandatoryStepDeclarationsError] If this method is called multiple times with a block.
      #
      # @example
      #
      #   class CreateUserCommand
      #     extend Komando::Command::Dsl
      #
      #     mandatory_steps do
      #       # Assuming an ActiveRecord-like User class exists
      #       User.create!(@attributes)
      #     end
      #   end
      #
      #   # Run the command with parameters gathered from the environment
      #   CreateUserCommand.new(:attributes => params[:user]).run!
      def mandatory_steps(&block)
        if block then
          # Called as a setter
          raise Komando::MultipleMandatoryStepDeclarationsError if @mandatory_steps
          @mandatory_steps = block
        else
          # Called as a query
          @mandatory_steps
        end
      end

      # Declares a new best effort step - one that will be executed, but will not stop processing.
      # If the block raises an exception, {Komando::Command#run!} will log and swallow the exception.
      # Best effort stop blocks have access to the same environment as {#mandatory_steps} blocks -
      # they execute within the same instance. You can pass values from one block to the next by
      # using instance variables.
      #
      # @example
      #
      #   class CreateUserCommand
      #     extend Komando::Command::Dsl
      #
      #     mandatory_steps do
      #       @user = User.create!(@attributes)
      #     end
      #
      #     best_effort_step("generate audit log record") do
      #       AuditLog.append(@user, @created_by)
      #     end
      #   end
      #
      #   # Run the command with parameters gathered from the environment
      #   CreateUserCommand.new(:attributes => params[:user], :created_by => current_user).run!
      def best_effort_step(name=nil, &block)
        @best_effort_steps ||= Array.new
        @best_effort_steps << [name, block]
      end

      # Helper method to access the declared blocks.
      #
      # @return [Array] The list of best effort blocks that were collected. This array may be empty.
      def best_effort_steps
        @best_effort_steps ||= Array.new
      end
    end
  end
end

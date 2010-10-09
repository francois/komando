module Komando
  module Command
    module Dsl

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

      attr_reader :best_effort_steps

      def best_effort_step(name=nil, &block)
        @best_effort_steps ||= Array.new
        @best_effort_steps << [name, block]
      end

    end
  end
end

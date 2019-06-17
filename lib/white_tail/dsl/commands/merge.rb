module WhiteTail
  module DSL
    module Commands
      class Merge < Base
        REQUIRED_OPTIONS = [:command]
        ALLOWED_OPTIONS = []

        def execute(execution_context)
          value = options[:command].execute(execution_context)
          execution_context.node.merge!(value)
        end
      end
    end
  end
end

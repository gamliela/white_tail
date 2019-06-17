module WhiteTail
  module DSL
    module Commands
      class Assign < Base
        REQUIRED_OPTIONS = [:command]
        ALLOWED_OPTIONS = [:node_name]

        def execute(execution_context)
          value = options[:command].execute(execution_context)
          execution_context.node[options[:node_name]] = value if options[:node_name]
        end
      end
    end
  end
end

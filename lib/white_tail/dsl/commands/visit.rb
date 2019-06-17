module WhiteTail
  module DSL
    module Commands
      class Visit < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class, :url]
        ALLOWED_OPTIONS = []

        def execute(execution_context)
          execution_context.session.visit(options[:url])
          page_node = options[:node_class].new
          page_execution_context = ExecutionContext.new(execution_context.session, page_node)
          Helpers.execute_script(script, page_execution_context)
          page_node
        end
      end
    end
  end
end

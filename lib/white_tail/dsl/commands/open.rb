module WhiteTail
  module DSL
    module Commands
      class Open < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class, :url]
        ALLOWED_OPTIONS = []

        def execute(execution_context)
          page_node = options[:node_class].new
          session = execution_context.session
          session.within_window(session.open_new_window) do
            session.visit(options[:url])
            page_execution_context = ExecutionContext.new(session, page_node)
            Helpers.execute_script(script, page_execution_context)
          end
          page_node
        end
      end
    end
  end
end

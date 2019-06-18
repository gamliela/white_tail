module WhiteTail
  module DSL
    module Commands
      class Visit < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:url]

        def execute(execution_context)
          if options[:url]
            page_node = options[:node_class].new
            session = execution_context.session
            session.within_window(session.open_new_window) do
              session.visit(options[:url])
              page_execution_context = ExecutionContext.new(session, page_node)
              Helpers.execute_script(script, page_execution_context)
              session.current_window.close
            end
            page_node
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end

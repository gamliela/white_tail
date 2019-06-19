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
            Helpers.with_new_window(execution_context, options[:url]) do
              page_execution_context = ExecutionContext.new(execution_context.session, page_node)
              Helpers.execute_script(script, page_execution_context)
            end
            page_node
          else
            Nodes::NIL
          end
        end
      end
    end
  end
end

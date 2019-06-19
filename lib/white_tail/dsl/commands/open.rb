module WhiteTail
  module DSL
    module Commands
      class Open < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator, :required]

        def execute(execution_context)
          Helpers.with_element(execution_context, options) do |element|
            url = element[:href]
            if url
              page_node = options[:node_class].new
              session = execution_context.session
              session.within_window(session.open_new_window) do
                session.visit(url)
                page_execution_context = ExecutionContext.new(session, page_node)
                Helpers.execute_script(script, page_execution_context)
                session.current_window.close
              end
              page_node
            elsif options[:required]
              raise ValidationError, "Attribute href not found"
            else
              Nodes::NIL
            end
          end
        end
      end
    end
  end
end

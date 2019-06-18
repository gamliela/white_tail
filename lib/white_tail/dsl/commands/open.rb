module WhiteTail
  module DSL
    module Commands
      class Open < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator, :required]

        def execute(execution_context)
          element = Helpers.find_element(execution_context, options)
          if element
            url = element[:href]
            raise ValidationError, "Attribute href not found" if url.nil? && options[:required]
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
            else
              Nodes::Field.new(nil)
            end
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end

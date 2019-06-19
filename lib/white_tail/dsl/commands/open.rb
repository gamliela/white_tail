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
              Helpers.with_new_window(execution_context, url) do
                page_execution_context = ExecutionContext.new(execution_context.session, page_node)
                Helpers.execute_script(script, page_execution_context)
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

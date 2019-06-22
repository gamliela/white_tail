module WhiteTail
  module DSL
    module Commands
      class Click < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator]

        def execute(execution_context)
          Helpers.with_element(execution_context, options) do |element|
            page_node = options[:node_class].new
            Helpers.with_marked_location(execution_context) do
              element.click
              page_execution_context = ExecutionContext.new(execution_context.session, page_node)
              Helpers.execute_script(script, page_execution_context)
              page_node
            end
          end
        end
      end
    end
  end
end

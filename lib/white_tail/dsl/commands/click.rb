module WhiteTail
  module DSL
    module Commands
      class Click < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator]

        def execute(execution_context)
          element = Helpers.find_element(execution_context, options)
          if element
            page_node = options[:node_class].new
            element.click
            page_execution_context = ExecutionContext.new(execution_context.session, page_node)
            Helpers.execute_script(script, page_execution_context)
            page_node
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end

module WhiteTail
  module DSL
    module Commands
      class Section < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator, :required]

        def execute(execution_context)
          Helpers.with_element(execution_context, options) do |element|
            section_node = options[:node_class].new
            section_execution_context = ExecutionContext.new(element, section_node)
            Helpers.execute_script(script, section_execution_context)
            section_node
          end
        end
      end
    end
  end
end

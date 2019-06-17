module WhiteTail
  module DSL
    module Commands
      class List < Base
        REQUIRED_OPTIONS = [:node_class, :command]
        ALLOWED_OPTIONS = [:locator, :required]

        def execute(execution_context)
          elements = Helpers.find_elements(execution_context, options)

          # first, build execution scopes for all elements.
          # it's important to do that before executing any of them, so browser doesn't change state.
          list_node = options[:node_class].new
          item_execution_contexts = elements.each_with_index.map do |element, index|
            ExecutionContext.new(element, list_node)
          end

          # now, build array of nodes. each item is built with the same script, that is stored on sections_class.
          # note that errors do not
          list_node += item_execution_contexts.map do |item_execution_context|
            options[:command].execute(item_execution_context)
          rescue StandardError => error
            DSL::Nodes::Error.new(error)
          end
          list_node
        end
      end
    end
  end
end

module WhiteTail
  module DSL
    module Commands
      class List
        ALLOWED_OPTIONS = %i[required]

        attr_reader :list_class, :locator, :command, :options

        def initialize(list_class, locator, command, **options)
          @list_class = list_class
          @locator = locator
          @command = command
          @options = options

          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          elements = Helpers.find_elements(execution_context, locator, options)

          # first, build execution scopes for all elements.
          # it's important to do that before executing any of them, so browser doesn't change state.
          list_node = list_class.new
          item_execution_contexts = elements.each_with_index.map do |element, index|
            ExecutionContext.new(element, list_node)
          end

          # now, build array of nodes. each item is built with the same script, that is stored on sections_class.
          # note that errors do not
          list_node += item_execution_contexts.map do |item_execution_context|
            command.execute(item_execution_context)
          rescue StandardError => error
            DSL::Nodes::Error.new(error)
          end
          list_node
        end
      end
    end
  end
end

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

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          elements = Helpers.find_elements(execution_scope, locator, options.merge(:multiple => true))

          # first, build execution scopes for all elements.
          # it's important to do that before executing any of them, so browser doesn't change state.
          item_execution_scopes = elements.each_with_index.map do |element, index|
            execution_scope.extend_instance(nil, locator, index, element.text)
          end

          # now, build array of nodes. each item is built with the same script, that is stored on sections_class.
          # note that errors do not
          list_node = list_class.new
          list_node += item_execution_scopes.map do |item_execution_scope|
            command.execute(item_execution_scope)
          rescue StandardError => error
            DSL::Nodes::Error.new(error)
          end
        end
      end
    end
  end
end

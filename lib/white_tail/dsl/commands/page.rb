module WhiteTail
  module DSL
    module Commands
      class Page
        include Helpers

        ALLOWED_OPTIONS = []

        attr_reader :page_component, :element_name, :url, :options

        def initialize(page_component, element_name, url, **options)
          @page_component = page_component
          @element_name = element_name
          @url = url
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          execution_scope.visit(url) if url
          execution_scope = execution_scope.new_instance
          ScriptExecutor.execute_for(page_component, execution_scope)
        rescue StandardError => error
          DSL::Components::Error.new(error)
        end
      end
    end
  end
end

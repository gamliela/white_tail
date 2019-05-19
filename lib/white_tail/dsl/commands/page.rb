module WhiteTail
  module DSL
    module Commands
      class Page < Base
        attr_reader :page_component, :url

        def initialize(page_component, element_name, url, **options)
          super(element_name, options)
          @page_component = page_component
          @url = url
        end

        def execute(execution_scope)
          execution_scope.session.visit(url) if url
          execution_scope = ExecutionScope.new(execution_scope.session, url)
          ScriptExecutor.execute_for(page_component, execution_scope)
        rescue StandardError => error
          DSL::Components::Error.new(error)
        end
      end
    end
  end
end

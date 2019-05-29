module WhiteTail
  module DSL
    module Commands
      class Page
        ALLOWED_OPTIONS = []

        attr_reader :page_class, :node_name, :url, :options

        def initialize(page_class, node_name, url, **options)
          @page_class = page_class
          @node_name = node_name
          @url = url
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          execution_scope.visit(url) if url
          execution_scope = execution_scope.new_instance
          ScriptExecutor.execute_for(page_class, execution_scope)
        rescue StandardError => error
          DSL::Nodes::Error.new(error)
        end
      end
    end
  end
end

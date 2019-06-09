module WhiteTail
  module DSL
    module Commands
      class Visit
        ALLOWED_OPTIONS = []

        attr_reader :page_class, :script, :url, :options

        def initialize(page_class, url, **options)
          @page_class = page_class
          @script = Helpers.extract_script!(page_class)
          @url = url
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          page_node = page_class.new
          execution_scope.visit(url) if url
          page_execution_scope = execution_scope.new_instance(page_node)
          Helpers.execute_script(script, page_execution_scope)
          page_node
        end
      end
    end
  end
end

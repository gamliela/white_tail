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

          Helpers.validate_required_option!(:url, url)
          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          execution_context.session.visit(url)
          page_node = page_class.new
          page_execution_context = ExecutionContext.new(execution_context.session, page_node)
          Helpers.execute_script(script, page_execution_context)
          page_node
        end

        def locate(*)
          nil
        end
      end
    end
  end
end

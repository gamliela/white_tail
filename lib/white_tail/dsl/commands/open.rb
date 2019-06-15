module WhiteTail
  module DSL
    module Commands
      class Open
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
          page_node = page_class.new
          session = execution_context.session
          session.within_window(session.open_new_window) do
            session.visit(url)
            page_execution_context = ExecutionContext.new(session, page_node)
            Helpers.execute_script(script, page_execution_context)
          end
          page_node
        end

        def locate(*)
          nil
        end
      end
    end
  end
end

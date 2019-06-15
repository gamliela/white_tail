module WhiteTail
  module DSL
    module Commands
      class Click
        ALLOWED_OPTIONS = []

        attr_reader :page_class, :script, :locator, :options

        def initialize(page_class, locator, **options)
          @page_class = page_class
          @script = Helpers.extract_script!(page_class)
          @locator = locator
          @options = options

          Helpers.validate_required_option!(:locator, locator)
          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          element = locate(execution_context)
          if element
            page_node = page_class.new
            element.click
            page_execution_context = ExecutionContext.new(execution_context.session, page_node)
            Helpers.execute_script(script, page_execution_context)
            page_node
          else
            Nodes::Field.new(nil)
          end
        end

        def locate(execution_context)
          Helpers.find_element(execution_context, locator, options)
        end
      end
    end
  end
end

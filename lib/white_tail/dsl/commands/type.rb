module WhiteTail
  module DSL
    module Commands
      class Type
        ALLOWED_OPTIONS = []

        attr_reader :locator, :text, :options

        def initialize(locator, text, **options)
          @locator = locator
          @text = text
          @options = options

          Helpers.validate_required_option!(:locator, locator)
          Helpers.validate_required_option!(:text, locator)
          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          element = locate(execution_context)
          element&.send_keys text
          Nodes::Field.new(element&.value)
        end

        def locate(execution_context)
          Helpers.find_element(execution_context, locator, options)
        end
      end
    end
  end
end

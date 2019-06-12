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
          Helpers.with_element(execution_context, locator, options) do |element|
            element.send_keys text
          end
        end
      end
    end
  end
end

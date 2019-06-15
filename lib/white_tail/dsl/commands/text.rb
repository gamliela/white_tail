module WhiteTail
  module DSL
    module Commands
      class Text
        ALLOWED_OPTIONS = %i[required unique]

        attr_reader :text_class, :locator, :options

        def initialize(text_class, locator, **options)
          @text_class = text_class
          @locator = locator
          @options = options

          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          elements = locate(execution_context)
          if elements.any?
            value = elements.map(&:text).join(' ')
          else
            value = nil
          end
          text_class.new(value)
        end

        def locate(execution_context)
          Helpers.find_elements(execution_context, locator, options)
        end
      end
    end
  end
end

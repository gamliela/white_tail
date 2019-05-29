module WhiteTail
  module DSL
    module Commands
      class Text
        ALLOWED_OPTIONS = %i[required multiple]

        attr_reader :text_class, :node_name, :locator, :options

        def initialize(text_class, node_name, locator, **options)
          @text_class = text_class
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          elements = Helpers.find_elements(execution_scope, locator, options)
          if elements.any?
            value = elements.map(&:text).join(' ')
          else
            value = nil
          end
          text_class.new(value)
        rescue StandardError => error
          DSL::Nodes::Error.new(error)
        end
      end
    end
  end
end

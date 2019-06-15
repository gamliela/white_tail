module WhiteTail
  module DSL
    module Commands
      class Validation
        ALLOWED_OPTIONS = []

        attr_reader :node_name, :locator, :options

        def initialize(node_name, locator, **options)
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          locate(execution_context)
        rescue ValidationError
          raise ValidationError.new(nil, node_name)
        end

        def locate(execution_context)
          Helpers.find_element(execution_context, locator, options.merge(:required => true))
        end
      end
    end
  end
end

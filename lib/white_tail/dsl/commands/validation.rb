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

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          execution_scope.find(locator)
        rescue Capybara::ElementNotFound
          raise ValidationFailed.new(nil, node_name)
        end
      end
    end
  end
end
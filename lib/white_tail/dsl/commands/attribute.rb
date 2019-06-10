module WhiteTail
  module DSL
    module Commands
      class Attribute
        ALLOWED_OPTIONS = %i[required]

        attr_reader :attribute_class, :locator, :attribute, :options

        def initialize(attribute_class, locator, attribute, **options)
          @attribute_class = attribute_class
          @locator = locator
          @attribute = attribute
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_context)
          element = Helpers.find_element(execution_context, locator, options)
          value = element&.[](attribute)

          raise "Attribute #{node_name} not found" if value.nil? && options[:required]

          attribute_class.new(value)
        end
      end
    end
  end
end

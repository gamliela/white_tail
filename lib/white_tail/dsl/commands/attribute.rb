module WhiteTail
  module DSL
    module Commands
      class Attribute < Base
        REQUIRED_OPTIONS = [:node_class, :attribute]
        ALLOWED_OPTIONS = [:locator, :required]

        def execute(execution_context)
          Helpers.with_element(execution_context, options) do |element|
            value = element[options[:attribute]]

            raise ValidationError, "Attribute #{node_name} not found" if value.nil? && options[:required]

            options[:node_class].new(value)
          end
        end
      end
    end
  end
end

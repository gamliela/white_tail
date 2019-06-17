module WhiteTail
  module DSL
    module Commands
      class WaitFor < Base
        REQUIRED_OPTIONS = [:locator]
        ALLOWED_OPTIONS = [:node_name]

        def execute(execution_context)
          Helpers.find_element(execution_context, options.merge(:required => true))
        rescue ValidationError
          raise ValidationError.new(nil, node_name)
        end
      end
    end
  end
end

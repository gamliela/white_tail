module WhiteTail
  module DSL
    module Commands
      class Base
        attr_reader :options

        def initialize(**options)
          @options = {}
          update(options)
        end

        def update(**new_options)
          new_options = @options.merge(new_options)
          validate!(new_options)
          @options = new_options
        end

        def validate!(new_options)
          Helpers.validate_options!(new_options, self.class::ALLOWED_OPTIONS, self.class::REQUIRED_OPTIONS)
        end
      end
    end
  end
end

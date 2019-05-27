module WhiteTail
  module DSL
    module Commands
      module Helpers
        def validate_options(allowed_options)
          illegal_options = options.keys - allowed_options
          raise "Illegal options were found: #{illegal_options}" if illegal_options.any?
        end
      end
    end
  end
end

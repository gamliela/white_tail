module WhiteTail
  module DSL
    module Commands
      module ScriptExecuter
        attr_reader :script

        def initialize(**options)
          @script = nil
          super(options)
        end

        def update(**new_options)
          new_script = Helpers.extract_script!(new_options)
          @script ||= new_script
          raise ScriptError, "Cannot update node_class because it will update the script" if @script != new_script
          super(new_options)
        end
      end
    end
  end
end

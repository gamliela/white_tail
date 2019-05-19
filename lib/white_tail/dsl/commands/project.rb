module WhiteTail
  module DSL
    module Commands
      class Project < Base
        attr_reader :project_component

        def initialize(project_component, element_name, **options)
          super(element_name, options)
          @project_component = project_component
        end

        def execute(execution_scope)
          ScriptExecutor.execute_for(project_component, execution_scope)
        end
      end
    end
  end
end

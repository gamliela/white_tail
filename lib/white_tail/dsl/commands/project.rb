module WhiteTail
  module DSL
    module Commands
      class Project
        include Helpers

        ALLOWED_OPTIONS = []

        attr_reader :project_component, :element_name, :options

        def initialize(project_component, element_name, **options)
          @project_component = project_component
          @element_name = element_name
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          execution_scope = execution_scope.new_instance
          ScriptExecutor.execute_for(project_component, execution_scope)
        rescue StandardError => error
          DSL::Components::Error.new(error)
        end
      end
    end
  end
end

module WhiteTail
  module DSL
    module Commands
      class ProjectCommand < BaseCommand
        attr_reader :project_class

        def initialize(project_class, element_name, **options)
          super(element_name, options)
          @project_class = project_class
        end

        def execute
          ScriptExecutor.new(project_class.script).execute
        end
      end
    end
  end
end

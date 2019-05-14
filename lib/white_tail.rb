require "white_tail/version"
require "white_tail/utils"
require "white_tail/projects"
require "white_tail/dsl"
require "white_tail/script_executor"

module WhiteTail
  def self.project(project_name, &block)
    DSL::Components.def_project(project_name, &block)
  end

  def self.execute(project_name)
    project_class = DSL::Components::resolve_project_class(project_name)
    command = DSL::Commands::ProjectCommand.new(project_class, project_name)
    command.execute
  end
end

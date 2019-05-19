require "capybara/dsl"
require "white_tail/version"
require "white_tail/utils"
require "white_tail/projects"
require "white_tail/dsl"
require "white_tail/execution_scope"
require "white_tail/script_executor"

module WhiteTail
  def self.project(project_name, &block)
    DSL::Components.def_project(project_name, &block)
  end

  def self.execute(project_name)
    project_component = DSL::Components::resolve_project_component(project_name)
    project_command = DSL::Commands::Project.new(project_component, project_name)
    session = Capybara::Session.new(:selenium_chrome)
    execution_scope = ExecutionScope.new(session)
    project_command.execute(execution_scope)
  end
end

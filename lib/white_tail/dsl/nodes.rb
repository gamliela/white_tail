require_relative "nodes/error"
require_relative "nodes/field"
require_relative "nodes/record"
require_relative "nodes/list"
require_relative "nodes/project"
require_relative "nodes/page"
require_relative "nodes/section"
require_relative "nodes/text"
require_relative "nodes/attribute"

module WhiteTail
  module DSL
    module Nodes
      NIL = Field.new(nil)

      def self.resolve_node_class_name(node_name, super_class = nil)
        prefix = node_name && WhiteTail::Utils::camel_case(node_name.to_s)
        suffix = super_class && super_class.name.split("::").last
        prefix || suffix
      end

      def self.def_node_class(namespace, super_class, node_name, &block)
        class_name = resolve_node_class_name(node_name, super_class)
        raise ScriptError, "#{class_name} is already defined on #{namespace}" if namespace.const_defined?(class_name, false)

        klass = Class.new(super_class)
        namespace.const_set(class_name, klass)
        klass.class_eval(&block) if block_given?

        klass
      end

      def self.def_project_class(project_name, &block)
        def_node_class(Projects, DSL::Nodes::Project, project_name, &block)
      end

      def self.resolve_project_class(project_name)
        Projects.const_get(resolve_node_class_name(project_name), false)
      end
    end
  end
end

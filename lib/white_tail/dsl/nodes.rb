require_relative "nodes/error"
require_relative "nodes/field"
require_relative "nodes/record"
require_relative "nodes/list"
require_relative "nodes/project"
require_relative "nodes/page"
require_relative "nodes/section"
require_relative "nodes/sections"
require_relative "nodes/text"
require_relative "nodes/attribute"

module WhiteTail
  module DSL
    module Nodes
      def self.def_node_class(namespace, super_class, node_name, &block)
        klass = self.resolve_node_class(namespace, super_class, node_name)
        klass.class_eval(&block) if block_given?
        klass
      end

      def self.resolve_node_class(namespace, super_class, node_name)
        prefix = WhiteTail::Utils::camel_case(node_name.to_s)
        suffix = super_class.name.split("::").last
        local_class_name = prefix + suffix

        unless namespace.const_defined?(local_class_name, false)
          namespace.const_set(local_class_name, Class.new(super_class))
        end

        namespace.const_get(local_class_name, false)
      end

      def self.def_project_class(project_name, &block)
        def_node_class(Projects, DSL::Nodes::Project, project_name, &block)
      end

      def self.resolve_project_class(project_name)
        resolve_node_class(Projects, DSL::Nodes::Project, project_name)
      end
    end
  end
end

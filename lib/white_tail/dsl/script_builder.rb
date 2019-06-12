module WhiteTail
  module DSL
    module ScriptBuilder
      module Helpers
        def self.delete_class_name_from_options(node_class, options)
          if node_class == Nodes::Page
            options.delete(:page_class)
          else
            nil
          end
        end

        def self.def_node_class(namespace, super_class, node_name, options, &block)
          node_class = delete_class_name_from_options(super_class, options)
          node_class || Nodes.def_node_class(namespace, super_class, node_name, &block)
        end

        def self.execute_node_command(namespace, super_class, node_name, command_class, command_args, **options, &block)
          node_class = def_node_class(namespace, super_class, node_name, options, &block)
          command_class.new(node_class, *command_args, options)
        end

        def self.assign_node_command(namespace, super_class, node_name, command_class, command_args, **options, &block)
          command = execute_node_command(namespace, super_class, node_name, command_class, command_args, **options, &block)
          Commands::Assignment.new(node_name, command)
        end

        def self.merge_node_command(namespace, super_class, node_name, command_class, command_args, **options, &block)
          command = execute_node_command(namespace, super_class, node_name, command_class, command_args, **options, &block)
          Commands::Merge.new(command)
        end
      end

      def script
        @script ||= Script.new
      end

      def visit(page_name, url, **options, &block)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Visit, [url], options, &block)
      end

      def open(page_name, url, **options, &block)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Open, [url], options, &block)
      end

      def click(page_name, locator, **options, &block)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Click, [locator], options, &block)
      end

      def type(*, locator, text, **options)
        script << Commands::Type.new(locator, text, options)
      end

      def validation(validation_name, locator, **options)
        script << Commands::Validation.new(validation_name, locator, options)
      end

      def within(locator, **options, &block)
        script << Helpers.merge_node_command(self, Nodes::Section, nil, Commands::Section, [locator], options, &block)
      end

      def section(section_name, locator, **options, &block)
        script << Helpers.assign_node_command(self, Nodes::Section, section_name, Commands::Section, [locator], options, &block)
      end

      def sections(list_name, locator, **options, &block)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        section_class = Nodes.def_node_class(list_class, Nodes::Section, nil, &block)
        section_command = Commands::Section.new(section_class, nil, options)
        list_command = Commands::List.new(list_class, locator, section_command, { :required => options[:required] })
        script << Commands::Assignment.new(list_name, list_command)
      end

      def text(text_name, locator, **options)
        script << Helpers.assign_node_command(self, Nodes::Text, text_name, Commands::Text, [locator], options)
      end

      def texts(list_name, locator, **options, &block)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        text_class = Nodes.def_node_class(list_class, Nodes::Text, nil, &block)
        text_command = Commands::Text.new(text_class, nil, options)
        list_command = Commands::List.new(list_class, locator, text_command, { :required => options[:required] })
        script << Commands::Assignment.new(list_name, list_command)
      end

      def attribute(attribute_name, locator, attribute, **options)
        script << Helpers.assign_node_command(self, Nodes::Attribute, attribute_name, Commands::Attribute, [locator, attribute], options)
      end

      def attributes(list_name, locator, attribute, **options)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        attribute_class = Nodes.def_node_class(list_class, Nodes::Attribute, nil)
        attribute_command = Commands::Attribute.new(attribute_class, nil, attribute, options)
        list_command = Commands::List.new(list_class, locator, attribute_command, { :required => options[:required] })
        script << Commands::Assignment.new(list_name, list_command)
      end
    end
  end
end

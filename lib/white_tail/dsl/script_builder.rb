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

        def self.execute_node_command(namespace, super_class, node_name, command_class, **options, &block)
          node_class = def_node_class(namespace, super_class, node_name, options, &block)
          command_class.new(options.merge(:node_class => node_class))
        end

        def self.assign_node_command(namespace, super_class, node_name, command_class, **options, &block)
          command = execute_node_command(namespace, super_class, node_name, command_class, **options, &block)
          Commands::Assign.new(:node_name => node_name, :command => command)
        end

        def self.merge_node_command(namespace, super_class, node_name, command_class, **options, &block)
          command = execute_node_command(namespace, super_class, node_name, command_class, **options, &block)
          Commands::Merge.new(:command => command)
        end
      end

      def script
        @script ||= Script.new
      end

      def visit(page_name, url, **options, &block)
        options = options.merge(:url => url)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Visit, options, &block)
      end

      def open(page_name, locator, **options, &block)
        options = options.merge(:locator => locator)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Open, options, &block)
      end

      def click(page_name, locator, **options, &block)
        options = options.merge(:locator => locator)
        script << Helpers.assign_node_command(self, Nodes::Page, page_name, Commands::Click, options, &block)
      end

      def type(*, locator, text, **options)
        options = options.merge(:locator => locator, :text => text)
        script << Commands::Type.new(options)
      end

      def wait_for(validation_name, locator, **options)
        options = options.merge(:node_name => validation_name, :locator => locator)
        script << Commands::WaitFor.new(options)
      end

      def within(locator, **options, &block)
        options = options.merge(:locator => locator)
        script << Helpers.merge_node_command(self, Nodes::Section, nil, Commands::Section, options, &block)
      end

      def section(section_name, locator, **options, &block)
        options = options.merge(:locator => locator)
        script << Helpers.assign_node_command(self, Nodes::Section, section_name, Commands::Section, options, &block)
      end

      def sections(list_name, locator, **options, &block)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        list_options = options.extract!(:max_items)
        section_class = Nodes.def_node_class(list_class, Nodes::Section, nil, &block)
        section_options = options.merge(:node_class => section_class, :locator => nil)
        section_command = Commands::Section.new(section_options)
        list_options.merge!(:node_class => list_class, :locator => locator, :command => section_command, :required => options[:required])
        list_command = Commands::List.new(list_options)
        script << Commands::Assign.new(:node_name => list_name, :command => list_command)
      end

      def load_more(node_name, locator, **options, &block)
        node_command = script.find_command_by_name(node_name)
        raise ScriptError, "Node #{node_name} cannot be found" if node_command.nil?
        load_more_options = options.merge(:node_name => node_name, :locator => locator, :command => node_command)
        script << Commands::LoadMore.new(load_more_options)
      end

      def text(text_name, locator, **options)
        options = options.merge(:locator => locator)
        script << Helpers.assign_node_command(self, Nodes::Text, text_name, Commands::Text, options)
      end

      def texts(list_name, locator, **options, &block)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        list_options = options.extract!(:max_items)
        text_class = Nodes.def_node_class(list_class, Nodes::Text, nil, &block)
        text_options = options.merge(:node_class => text_class, :locator => nil)
        text_command = Commands::Text.new(text_options)
        list_options.merge!(:node_class => list_class, :locator => locator, :command => text_command, :required => options[:required])
        list_command = Commands::List.new(list_options)
        script << Commands::Assign.new(:node_name => list_name, :command => list_command)
      end

      def attribute(attribute_name, locator, attribute, **options)
        options = options.merge(:locator => locator, :attribute => attribute)
        script << Helpers.assign_node_command(self, Nodes::Attribute, attribute_name, Commands::Attribute, options)
      end

      def attributes(list_name, locator, attribute, **options)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        list_options = options.extract!(:max_items)
        attribute_class = Nodes.def_node_class(list_class, Nodes::Attribute, nil)
        attribute_options = options.merge(:node_class => attribute_class, :locator => nil, :attribute => attribute)
        attribute_command = Commands::Attribute.new(attribute_options)
        list_options.merge!(:node_class => list_class, :locator => locator, :command => attribute_command, :required => options[:required])
        list_command = Commands::List.new(list_options)
        script << Commands::Assign.new(:node_name => list_name, :command => list_command)
      end
    end
  end
end

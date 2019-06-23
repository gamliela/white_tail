module WhiteTail
  module DSL
    module Commands
      class LoadMore < Base
        REQUIRED_OPTIONS = [:node_name, :command]
        ALLOWED_OPTIONS = [:locator, :required, :times]

        def initialize(**options)
          super(options)
          raise ScriptError, "Cannot load_more #{node_name}" unless options[:command].class <= Commands::Assign
          options[:command].update_command(:locate_once => true)
        end

        def execute(execution_context)
          # initialize results with array that contain the already computed value
          results = []
          # save a stack of browser locations
          marked_locations = []
          times = 0
          loop do
            # add the last obtained results to the list of results
            results << execution_context.node[options[:node_name]]

            # do not load more than :times
            break if options[:times] && (times >= options[:times])
            times += 1

            # find and click an element to obtain more results
            element = Helpers.find_element(execution_context, options)
            break if element.nil?

            # mark current location so we can go back there after the click
            marked_locations << Helpers.mark_location(execution_context)
            element.click

            # run the original command again, so new results are set on execution_context
            options[:command].execute(execution_context)

          rescue StandardError => error
            # in case of error just add it to the list and abort. this way we don't lose the previous items.
            results << DSL::Nodes::Error.new(error)
            break
          end

          # assign all results back on the original node (use flatten so all "pages" will result in one long list)
          execution_context.node[options[:node_name]] = DSL::Nodes::List.new(results.flatten(1))
        ensure
          # return the browser to the original location
          # effectively, this will
          marked_locations.reverse_each { |location_mark| Helpers.unmark_location(execution_context, location_mark) }
        end
      end
    end
  end
end

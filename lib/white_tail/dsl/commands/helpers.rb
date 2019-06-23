module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_required_option!(option_key, option_value)
          raise ScriptError, "Required option is missing: #{option_key}" if option_value.nil?
        end

        def self.validate_options!(options, allowed_options = [], required_options = [])
          illegal_options = options.keys - allowed_options - required_options
          raise ScriptError, "Illegal options were found: #{illegal_options}" if illegal_options.any?
          required_options.each do |option_key|
            validate_required_option!(option_key, options[option_key])
          end
        end

        def self.extract_script!(node_class:, **)
          raise ScriptError, "#{node_class} has no script defined" unless node_class.respond_to?('script') && node_class.script&.commands
          node_class.script
        end

        def self.find_elements(execution_context, locator: nil, required: nil, unique: nil, locate_once: nil, max_items: nil, **)
          return [execution_context.element] unless locator

          if locate_once
            elements = execution_context.element.find_all(locator, &self.method(:locate_once_filter))
          else
            elements = execution_context.element.find_all(locator)
          end

          raise ValidationError, "Element not found" if elements.empty? && required
          raise ValidationError, "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && unique

          if max_items
            elements.first(max_items)
          else
            elements
          end
        end

        def self.locate_once_filter(element)
          return false if element['data-white-tail-located']
          element.execute_script('this.dataset.whiteTailLocated = true')
          true
        end

        def self.find_element(execution_context, options = {})
          elements = self.find_elements(execution_context, options.merge(:unique => true))
          elements.first
        end

        def self.with_element(execution_context, **options)
          element = Helpers.find_element(execution_context, options)
          if element && block_given?
            yield element
          else
            Nodes::NIL
          end
        end

        def self.with_new_window(execution_context, url = nil)
          session = execution_context.session
          new_window = session.open_new_window
          session.within_window(new_window) do
            session.visit(url) if url
            yield
          ensure
            new_window.close
          end
        end

        # push a state (string) into browser history, *just before* the top of the history stack
        def self.push_history_mark(session)
          @push_history_mark_counter = (@push_history_mark_counter || 0) + 1
          location_mark = "whiteTailHistoryMark#{@push_history_mark_counter}"
          session.execute_script <<~JS
            (function(newState){
              const oldState = window.history.state;
              window.history.replaceState(newState, document.title, location.href);
              window.history.pushState(oldState, document.title, location.href);
            })('#{location_mark}')
          JS
          location_mark
        end

        # pop all frames from history stack until reaching location_mark, *but keep* the top of the history stack
        def self.pop_history_mark(session, location_mark)
          top_state = session.evaluate_script("window.history.state")
          3.times do
            session.go_back
            almost_top_state = session.evaluate_script("window.history.state")
            if location_mark == almost_top_state
              session.evaluate_script("window.history.replaceState('#{top_state}', document.title, location.href);")
              return
            end
            top_state = almost_top_state
          end

          # we tried too many times, raise an error.
          # on a well structured script and website, 1 try should be enough.
          # note that it's not possible to know if we've reached to the end of history
          # so an hard coded limit must be used. also, history has an unknown size limit.
          raise BrowserStateError, "Unexpected history position"
        end

        def self.mark_location(execution_context)
          {
            :window_handle => execution_context.session.current_window.handle,
            :history_mark => push_history_mark(execution_context.session)
          }
        end

        def self.unmark_location(execution_context, location_mark)
          # assert we're still on the same window
          new_window_handle = execution_context.session.current_window.handle
          raise BrowserStateError, "Unexpected window" if location_mark[:window_handle] != new_window_handle

          # assert we're still on the same page (try to go_back if not)
          pop_history_mark(execution_context.session, location_mark[:history_mark])
        end

        # for now this only freeze history state of the current window
        # in the future, we might also assert/freeze window state or url state
        def self.with_marked_location(execution_context, &block)
          location_mark = mark_location(execution_context)
          yield
        ensure
          unmark_location(execution_context, location_mark)
        end

        def self.execute_script(script, execution_context)
          script.commands.each do |command|
            command.execute(execution_context)
          end
          nil
        end
      end
    end
  end
end

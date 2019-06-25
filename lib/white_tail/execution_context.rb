require 'forwardable'

module WhiteTail
  class ExecutionContext
    attr_reader :node

    private_class_method :new

    def self.from_session(session, node = nil)
      raise ArgumentError, "session cannot be nil" if session.nil?
      new(session, node)
    end

    def at_window(window, node = nil)
      raise ArgumentError, "window cannot be nil" if window.nil?
      new_session(session, node).tap do |context|
        context.window = window
      end
    end

    def at_new_page(node = nil)
      raise BrowserStateError, "Cannot create ExecutionContext with page at a different window" if session.current_window.handle != window

      at_window(window, node).tap do |context|
        context.history = history
        context.page = context.history.length
      end
    end

    def at_element(element, node = nil)
      raise BrowserStateError, "Cannot create ExecutionContext with nil element" if element.nil?
      raise BrowserStateError, "Cannot create ExecutionContext with element of different session" if element.session != session

      # make sure we can reload this element after page navigations
      element.allow_reload! if element.respond_to?(:allow_reload!)

      at_new_page(node).tap do |context|
        context.element = element
      end
    end

    def at_action(node = nil, &block)
      raise BrowserStateError, "Element is not set on ExecutionContext" if element.nil?
      restore_browser_state

      # save location mark in history and perform the action
      history << push_history_mark
      element.instance_eval(&block) if block_given?

      at_element(element, node)
    end

    # it is assumed that we're not going to change the state
    def get_element
      raise BrowserStateError, "Element is not set on ExecutionContext" if element.nil?
      restore_browser_state

      element
    end

    private

    attr_accessor :session, :window, :history, :page, :element

    def initialize(session, node = nil)
      @session = session
      @window = session.current_window.handle
      @history = []
      @page = 0
      @element = nil
      @node = node
    end

    def restore_browser_state
      # assert we're still on the same window
      session.switch_to_window(window)

      # assert we didn't clean the history elsewhere
      raise BrowserStateError, "Browser is too early on the history stack" if history.size < page

      # go back in history browser until we hit base
      history.pop(history.size - page).reverse_each(&:pop_history_mark)
    end

    # push a state (string) into browser history, *just before* the top of the history stack
    def push_history_mark
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
    def pop_history_mark(location_mark)
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
  end
end

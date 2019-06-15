module WhiteTail
  class ExecutionContext
    attr_reader :element, :node

    def initialize(element, node)
      @element = element
      @node = node

      # make sure we can reload this element after page navigations
      element.allow_reload! if element.respond_to?(:allow_reload!)
    end

    def session
      element.is_a?(Capybara::Session) ? element : element.session
    end
  end
end

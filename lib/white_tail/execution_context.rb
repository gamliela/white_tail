module WhiteTail
  class ExecutionContext
    attr_reader :element, :node

    def initialize(element, node)
      @element = element
      @node = node
    end

    def page
      element.is_a?(Capybara::Session) ? element : element.session
    end
  end
end

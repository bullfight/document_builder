module DocumentBuilder
  class Property
    attr_reader :name, :selector, :type, :node

    def initialize(name, type: nil, selector: nil)
      @name = name
      @selector = selector
      @type = type || Coercion::TextProperty
    end

    def call(document)
      return nil if document.nil?

      if selector.nil? || document.name == selector
        @node = document
      else
        @node =  document.at_xpath(selector)
      end

      type.call(@node)
    end
  end
end

module DocumentBuilder
  class Tag
    attr_reader :name, :selector, :type, :node

    def initialize(name, type: nil, selector: nil)
      @name = name
      @selector = selector
      @type = type || Coercion::TextProperty
    end

    def call(document)
      return nil if document.nil?

      @node = selector.nil? ? document : document.attributes[selector]
      type.call(@node)
    end
  end
end

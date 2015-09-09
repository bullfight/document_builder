module DocumentBuilder
  class Collection
    include Enumerable
    attr_reader :name, :selector, :type, :node

    def initialize(name, selector:, type:)
      @name = name
      @selector = selector
      @type = type
    end

    def call(document)
      return nil if document.nil?
      @node = document.xpath(selector)
      self
    end

    def each
      @node.each do |element|
        yield type.new(element)
      end
    end
  end
end

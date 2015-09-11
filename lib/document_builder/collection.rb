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
        yield type.call(element)
      end
    end

    def to_s(*args)
      JSON.pretty_generate(to_hash)
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)}> Attributes: " + JSON.pretty_generate(to_hash)
    end

    def to_json(*args)
      JSON.generate(to_hash)
    end

    def to_hash
      entries.map(&:to_hash)
    end
  end
end

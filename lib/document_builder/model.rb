module DocumentBuilder
  module Model
    module ClassMethods
      def property(name, selector: nil, type: nil)
        @attributes ||= {}
        @attributes[name.to_sym] = Property.new(name,
          selector: selector, type: type)
      end

      def tag(name, selector: nil, type: nil)
        @attributes ||= {}
        @attributes[name.to_sym] = Tag.new(name,
          selector: selector, type: type)
      end

      def collection(name, selector: nil, type: nil)
        @attributes ||= {}
        @attributes[name.to_sym] = Collection.new(name,
          selector: selector, type: type)
      end

      def root(selector)
        @root = selector
      end

      def inherited(subclass)
        subclass.instance_variable_set(:@attributes, @attributes)
        subclass.instance_variable_set(:@root, @root)
        super
      end

      def call(document)
        self.new(document)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include Coercion
      end
    end

    def initialize(document)
      @document = document
    end

    def document
      if root && @document.name != root
        @document.at_xpath(root)
      else
        @document
      end
    end

    def root
      self.class.instance_variable_get(:@root)
    end

    def attributes
      self.class.instance_variable_get(:@attributes)
    end

    def [](key)
      attributes[key].call(document)
    end

    def method_missing(name, *args)
      attributes[name].call(document)
    rescue NoMethodError => e
      raise NoMethodError.new("undefined method '#{name}' for #{self.class}")
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
      attributes.inject({}) do |acc, (key, value)|
        obj = value.call(document)
        acc[key] = obj.respond_to?(:to_hash) ? obj.to_hash : obj
        acc
      end
    end
  end
end

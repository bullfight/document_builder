module DocumentBuilder
  module Model
    module ClassMethods
      def add_attribute(name, attribute)
        @attributes ||= {}
        @attributes[name.to_sym] = attribute
      end

      def property(name, selector: nil, type: nil)
        add_attribute name, Property.new(name, selector: selector, type: type)
      end

      def tag(name, selector: nil, type: nil)
        add_attribute name, Tag.new(name, selector: selector, type: type)
      end

      def collection(name, selector: nil, type: nil)
        add_attribute name, Collection.new(name, selector: selector, type: type)
      end

      def root(selector)
        @root = selector
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

    def get_attribute(name)
      if respond_to?(name)
        public_send(name)
      else
        attributes[name].call(document)
      end
    end

    def add_attribute(name, attribute)
      self.class.add_attribute(name, attribute)
    end

    def [](key)
      get_attribute(key)
    end

    def method_missing(name, *args)
      get_attribute(name)
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
        obj = get_attribute(key)
        acc[key] = obj.respond_to?(:to_hash) ? obj.to_hash : obj
        acc
      end
    end
  end
end

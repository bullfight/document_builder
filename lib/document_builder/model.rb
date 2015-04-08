module DocumentBuilder
  module Model
    module ClassMethods
      def attribute(name, xpath = nil, coercion = TextAttribute)
        @attributes ||= []
        @attributes << Attribute.new(name, xpath || name.to_s, coercion)
      end

      def inherited(subclass)
        subclass.instance_variable_set(:@attributes, @attributes)
        super
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include Coercion

        attr_reader :document
      end
    end

    def initialize(document)
      @document = document
    end

    def attributes
      self.class.instance_variable_get(:@attributes)
    end

    def [](key)
      attributes.select { |item| item.name == key.to_sym}.first.call(document)
    end

    def method_missing(name, *args)
      attributes.select { |item| item.name == name }.first.call(document)
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
        value = key.call(document)
        acc[key.name] = value.respond_to?(:to_hash) ? value.to_hash : value
        acc
      end
    end
  end
end

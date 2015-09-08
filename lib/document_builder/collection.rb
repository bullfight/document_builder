module DocumentBuilder
  module Collection
    module ClassMethods
      def call(document, params = {})
        root = @root || params[:root]
        unless document.name == root
          document = document.xpath(root)
        end

        document.nil? ? nil : self.coerce(document)
      end

      def collection(value, root, parser)
        @collection = Property.new(value, root, parser)
      end

      def inherited(subclass)
        subclass.instance_variable_set(:@collection, @collection)
        super
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include Model
        include Enumerable
      end
    end

    def collection
      self.class.instance_variable_get(:@collection)
    end

    def each(&block)
      document.xpath(collection.root).each do |item|
        block.call(
          collection.call(item)
        )
      end
    end

    def data
      lazy
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)}> { data: #{data} } }"
    end

    def to_hash
      { data: data }
    end
  end
end

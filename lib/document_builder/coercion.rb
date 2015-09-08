module DocumentBuilder
  module Coercion
    module ClassMethods
      def root(value)
        @root = value
      end

      def call(document, params = {})
        root = @root || params[:root]
        unless document.name == root
          document = document.at_xpath(root)
        end

        document.nil? ? nil : self.coerce(document)
      end

      def coerce(document)
        self.new(document)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end

  class TextProperty
    include Coercion
    def self.coerce(document)
      document.text
    end
  end

  class IntegerProperty
    include Coercion
    def self.coerce(document)
      Integer(document.text)
    end
  end

  class TimeProperty
    include Coercion
    def self.coerce(document)
      Time.parse(document.text)
    end
  end

  class UtcTimeProperty
    include Coercion
    def self.coerce(document)
      Time.use_zone("UTC") do
        Time.zone.parse(document.text)
      end
    end
  end

  class ElementProperty
    include Coercion
    def self.call(document, params = {})
      element = document.properties[params[:root].to_s]
      element.nil? ? nil : self.coerce(element)
    end

    def self.coerce(document)
      document.value
    end
  end

  class ChildProperty
    include Coercion
    def self.call(document, params = {})
      child = document.children
      child.empty? ? nil : self.coerce(child)
    end

    def self.coerce(document)
      document.text
    end
  end
end

module DocumentBuilder
  module Coercion
    module ClassMethods
      def xpath(value)
        @xpath = value
      end

      def call(document, params = {})
        root = @xpath || params[:xpath]
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

  class TextAttribute
    include Coercion
    def self.coerce(document)
      document.text
    end
  end

  class IntegerAttribute
    include Coercion
    def self.coerce(document)
      Integer(document.text)
    end
  end

  class TimeAttribute
    include Coercion
    def self.coerce(document)
      Time.parse(document.text)
    end
  end

  class UtcTimeAttribute
    include Coercion
    def self.coerce(document)
      Time.use_zone("UTC") do
        Time.zone.parse(document.text)
      end
    end
  end

  class ElementAttribute
    include Coercion
    def self.call(document, params = {})
      element = document.attributes[params[:xpath].to_s]
      element.nil? ? nil : self.coerce(element)
    end

    def self.coerce(document)
      document.value
    end
  end

  class ChildAttribute
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

module DocumentBuilder
  module Coercion
    module ClassMethods
      def call(document)
        document.nil? ? nil : self.coerce(document)
      end

      def coerce(document)
        self.new(document)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
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
  end
end

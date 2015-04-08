module DocumentBuilder
  class Attribute < Struct.new(:name, :xpath, :coercion)
    def call(document, params = {})
      coercion.call(document, { xpath: xpath })
    end
  end
end

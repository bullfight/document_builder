module DocumentBuilder
  class Property < Struct.new(:name, :root, :coercion)
    def call(document, params = {})
      coercion.call(document, { root: root })
    end
  end
end

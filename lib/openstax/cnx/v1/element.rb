module OpenStax::Cnx::V1
  class Element
    attr_reader :node

    def initialize(node:)
      @node = node
    end
  end
end

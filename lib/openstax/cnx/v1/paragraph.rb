module OpenStax::Cnx::V1
  class Paragraph < Element
    MATCH_PARAGRAPH = '//p[@id]'

    def initialize(node:)
      super
    end

    def text
      node.text
    end

    def id
      node.attr('id').value
    end

    def self.matcher
      MATCH_PARAGRAPH
    end

    def self.matches?(node)
      node.matches?(MATCH_PARAGRAPH)
    end
  end
end

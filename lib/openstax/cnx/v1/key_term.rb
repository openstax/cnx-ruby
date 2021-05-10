module OpenStax::Cnx::V1
  class KeyTerm < Element
    MATCH_KEY_TERM = "//*[contains(@class, 'os-glossary-container')]//dl"

    MATCH_KEY_TERM_TEXT = ".//dt"
    MATCH_KEY_TERM_DESCRIPTION = ".//dd"

    def initialize(node:)
      super
    end

    def description
      node.xpath(MATCH_KEY_TERM_DESCRIPTION).text
    end

    def id
      node.attr('id')
    end

    def term
      node.xpath(MATCH_KEY_TERM_TEXT).text
    end

    def self.matcher
      MATCH_KEY_TERM
    end

    def self.matches?(node)
      node.matches?(MATCH_KEY_TERM)
    end
  end
end

module OpenStax::Cnx::V1
  class Figure < Element
    MATCH_FIGURE = "//*[contains(@class, 'os-figure')]"

    MATCH_FIGURE_CAPTION = ".//*[contains(@class, 'os-caption')]"
    MATCH_FIGURE_ALT_TEXT = './/*[@data-alt]'
    MATCH_FIGURE_ELEM = './/figure'

    def initialize(node:)
      super
    end

    def caption
      node.xpath(MATCH_FIGURE_CAPTION).first.try(:text)
    end

    def id
      node.xpath(MATCH_FIGURE_ELEM).first.attr("id")
    end

    def alt_text
      node.xpath(MATCH_FIGURE_ALT_TEXT).first.attr('data-alt')
    end

    def self.matcher
      MATCH_FIGURE
    end

    def self.matches?(node)
      node.matches?(MATCH_FIGURE)
    end
  end
end

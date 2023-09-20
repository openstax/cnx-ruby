module OpenStax::Cnx::V1
  class Figure < Element
    MATCH_FIGURE = "//*[contains(@class, 'os-figure')]"

    MATCH_FIGURE_CAPTION = ".//*[contains(@class, 'os-caption')]"
    MATCH_FIGURE_ALT_TEXT = './/*[@alt]'
    MATCH_FIGURE_DATA_ALT_TEXT = './/*[@data-alt]'
    MATCH_FIGURE_ELEM = './/figure'

    def initialize(node:)
      super
    end

    def caption
      node.at_xpath(MATCH_FIGURE_CAPTION).try(:text)
    end

    def id
      node.at_xpath(MATCH_FIGURE_ELEM).attr('id')
    end

    def alt_text
      node.at_xpath(MATCH_FIGURE_ALT_TEXT).try(:attr, 'alt') ||
      node.at_xpath(MATCH_FIGURE_DATA_ALT_TEXT).try(:attr, 'data-alt')
    end

    def self.matcher
      MATCH_FIGURE
    end

    def self.matches?(node)
      node.matches?(MATCH_FIGURE)
    end
  end
end

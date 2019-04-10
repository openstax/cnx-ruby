require 'spec_helper'

RSpec.describe OpenStax::Cnx::V1::Paragraph do

  let(:html) do
    <<-FIGURE
    <html>
      <p id="import-auto-id2747641">What is your first reaction when you hear the word “physics”? Did you imagine working through difficult equations or memorizing formulas that seem to have no real use in life outside the physics classroom? Many people come to the subject of physics with a bit of fear. But as you begin your exploration of this broad-ranging subject, you may soon come to realize that physics plays a much larger role in your life than you first thought, no matter your life goals or career choice.
      </p>
    </html>
    FIGURE
  end

  let(:content_dom) { Nokogiri::HTML(html) }
  let(:paragraph_match) { content_dom.xpath(described_class.matcher) }
  let(:figure) { described_class.new(node: paragraph_match) }

  describe ".matcher" do
    it "finds the paragraph" do
      expect(paragraph_match.count).to eq 1
    end
  end

  describe ".matches?" do
    it "finds the paragraph" do
      expect(described_class.matches?(paragraph_match.first)).to be_truthy
    end

    it "should not find a figure in the paragraph node" do
      expect(OpenStax::Cnx::V1::Figure.matches?(paragraph_match.first)).to_not be_truthy
    end
  end

  describe "#text" do
    it "finds the paragraph text" do
      expect(paragraph_match.text).to include 'subject of physics'
    end
  end
end

require 'spec_helper'

RSpec.describe OpenStax::Cnx::V1::Figure do

  let(:html) do
    <<-FIGURE
    <html>
      <div class="os-figure">
          <figure class="splash" id="import-auto-id2688158">
             <span data-alt="The spiral galaxy Andromeda is shown." data-type="media" id="import-auto-id3147051">
               <img alt="The spiral galaxy Andromeda is shown." data-media-type="image/jpg" id="1513" src="/resources/d47864c2ac77d80b1f2ff4c4c7f1b2059669e3e9">
             </span>
	        </figure>
          <div class="os-caption-container">
            <span class="os-title-label">Figure </span>
            <span class="os-number">1.1</span>
            <span class="os-divider"> </span>
            <span class="os-caption">Galaxies are as immense as atoms are small. Yet the same laws of physics describe both, and all the rest of nature—an indication of the underlying unity in the universe. The laws of physics are surprisingly few in number, implying an underlying simplicity to nature’s apparent complexity. (credit: NASA, JPL-Caltech, P. Barmby, Harvard-Smithsonian Center for Astrophysics)
             </span>
          </div>
      </div>
    </html>
    FIGURE
  end

  let(:content_dom) { Nokogiri::HTML(html) }
  let(:figure_match) { content_dom.xpath(described_class.matcher).first }
  let(:figure) { described_class.new(node: figure_match) }

  describe ".matcher" do
    it "finds the figure" do
      expect(figure_match.count).to eq 1
    end
  end

  describe ".matches?" do
    it "finds the figure" do
      expect(described_class.matches?(figure_match)).to be_truthy
    end

    it "should not find a paragraph in the figure node" do
      expect(OpenStax::Cnx::V1::Paragraph.matches?(figure_match)).to_not be_truthy
    end
  end

  describe "#caption" do
    it "finds the figure caption" do
      expect(figure.caption).to include 'Barmby'
    end
  end

  describe "#id" do
    it "finds the figure id" do
      expect(figure.id).to eq 'import-auto-id2688158'
    end
  end

  describe "#alt_text" do
    it "finds the figure alt_text" do
      expect(figure.alt_text).to include 'Andromeda'
    end
  end
end

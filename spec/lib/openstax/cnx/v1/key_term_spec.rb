require 'spec_helper'

RSpec.describe OpenStax::Cnx::V1::KeyTerm do

  let(:html) do
    <<-KEYTERM
    <html>
    <div class="os-eoc os-glossary-container" data-type="composite-page">
      <dl id="fs-id1167066170930">
        <dt id="54">accuracy</dt>
        <dd id="fs-id1167066170933">how close a measurement is to the correct value for that measurement</dd>
      </dl>
      <dl id="fs-id1167066170936">
        <dt id="55">ampere</dt>
        <dd id="fs-id1167066170939">the SI unit for electrical current</dd>
      </dl>
    </div>
    </html>
    KEYTERM
  end

  let(:content_dom) { Nokogiri::HTML(html) }
  let(:key_term_match) { content_dom.xpath(described_class.matcher).first }
  let(:key_term) { described_class.new(node: key_term_match) }

  describe ".matcher" do
    it "finds the key terms" do
      expect(key_term_match.count).to eq 2
    end
  end

  describe ".matches?" do
    it "finds the key term" do
      expect(described_class.matches?(key_term_match)).to be_truthy
    end
  end

  describe "#term" do
    it "finds the term in key term" do
      expect(key_term.term).to include 'accuracy'
    end
  end

  describe "#id" do
    it "finds the key term id" do
      expect(key_term.id).to eq 'fs-id1167066170930'
    end
  end

  describe "#description" do
    it "finds the key term description" do
      expect(key_term.description).to include 'how close a measurement is to the correct value for that measurement'
    end
  end
end

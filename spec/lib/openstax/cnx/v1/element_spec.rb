require 'spec_helper'
require 'vcr_helper'

RSpec.describe OpenStax::Cnx::V1::Element, type: :external, vcr: VCR_OPTS do

  let(:cnx_book_id) { '031da8d3-b525-429c-80cf-6c8ed997733a' }

  let(:desired_elements) {
    [
      OpenStax::Cnx::V1::Figure,
      OpenStax::Cnx::V1::Paragraph
    ]
  }

  subject(:elements) {
    OpenStax::Cnx::V1::Book.new(id: cnx_book_id).
      root_book_part.
      pages[1].
      elements(element_classes: desired_elements)
  }

  subject(:elements_filtered) {
    page = OpenStax::Cnx::V1::Book.new(id: cnx_book_id).root_book_part.pages[1]
    page.remove_elements(xpath: "//p")
    page.elements(element_classes: desired_elements)
  }

  it "finds the given elements within the book" do
    OpenStax::Cnx::V1.with_archive_url("https://archive.cnx.org/contents") do
      expect(elements.count).to eq 5
      expect(elements[0]).to be_instance_of(OpenStax::Cnx::V1::Figure)
      expect(elements[1]).to be_instance_of(OpenStax::Cnx::V1::Paragraph)
      expect(elements[2]).to be_instance_of(OpenStax::Cnx::V1::Paragraph)
      expect(elements[3]).to be_instance_of(OpenStax::Cnx::V1::Paragraph)
      expect(elements[4]).to be_instance_of(OpenStax::Cnx::V1::Paragraph)
    end
  end

  it "omits the given elements within the book" do
    OpenStax::Cnx::V1.with_archive_url("https://archive.cnx.org/contents") do
      expect(elements_filtered.count).to eq 1
      expect(elements_filtered[0]).to be_instance_of(OpenStax::Cnx::V1::Figure)
    end
  end
end

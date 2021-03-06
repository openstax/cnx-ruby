# coding: utf-8
require 'spec_helper'
require 'vcr_helper'

RSpec.describe OpenStax::Cnx::V1::Page, type: :external, vcr: VCR_OPTS do

  context 'with parts of k12phys' do
    before(:all) do
      OpenStax::Cnx::V1.with_archive_url("https://archive-staging-tutor.cnx.org") do
        cnx_page_infos = [
          {
            id: '3005b86b-d993-4048-aff0-500256001f42',
            title: '<span class="os-number">1.1</span><span class="os-divider"> </span><span class="os-text">The Science of Biology</span>',
            expected: {
              los: ['k12phys-ch03-s02-lo01', 'k12phys-ch03-s02-lo02'],
              tags: [
                {
                  value: 'context-cnxmod:3005b86b-d993-4048-aff0-500256001f42',
                  type: :cnxmod
                },
                {
                  value: 'teks-112-39-c-4a',
                  type: :teks,
                  name: '(4A)',
                  description: 'Generate and interpret graphs and charts describing different types of motion, including the use of real-time technology such as motion detectors or photogates.'
                },
                {
                  value: 'teks-112-39-c-4b',
                  type: :teks,
                  name: '(4B)',
                  description: 'Describe and analyze motion in one dimension using equations with the concepts of distance, displacement, speed, average velocity, instantaneous velocity, and acceleration.'
                },
                {
                  value: 'k12phys-ch03-s02-lo01',
                  type: :lo,
                  description: 'Explain the kinematic equations related to acceleration and illustrate them with graphs.',
                  teks: 'teks-112-39-c-4a'
                },
                {
                  value: 'k12phys-ch03-s02-lo02',
                  type: :lo,
                  description: 'Apply the kinematic equations and related graphs to problems involving acceleration.',
                  teks: 'teks-112-39-c-4a'
                }
              ],
              is_intro: false
            }
          },
          {
            id: '1bb611e9-0ded-48d6-a107-fbb9bd900851',
            title: '<span class="os-text">Introduction</span>',
            expected: {
              los: [],
              tags: [
                {
                  value: 'context-cnxmod:1bb611e9-0ded-48d6-a107-fbb9bd900851',
                  type: :cnxmod
                }
              ],
              is_intro: true
            }
          },
          {
            id: '95e61258-2faf-41d4-af92-f62e1414175a',
            title: 'Force',
            expected: {
              los: ['k12phys-ch04-s01-lo01', 'k12phys-ch04-s01-lo02'],
              tags: [
                {
                  value: 'context-cnxmod:95e61258-2faf-41d4-af92-f62e1414175a',
                  type: :cnxmod
                },
                {
                  value: 'k12phys-ch04-s01-lo01',
                  type: :lo,
                  description: 'Differentiate between force, net force, and dynamics',
                  teks: 'teks-112-39-c-4c'
                },
                {
                  value: 'k12phys-ch04-s01-lo02',
                  type: :lo,
                  description: 'Draw a free-body diagram',
                  teks: 'teks-112-39-c-4e'
                },
                {
                  value: 'teks-112-39-c-4c',
                  type: :teks,
                  name: '(4C)',
                  description: 'analyze and describe accelerated motion in two dimensions using equations, including projectile and circular examples'
                },
                {
                  value: 'teks-112-39-c-4e',
                  type: :teks,
                  name: '(4E)',
                  description: 'develop and interpret free-body diagrams'
                }
              ],
              is_intro: false
            }
          },
          {
            id: '640e3e84-09a5-4033-b2a7-b7fe5ec29dc6',
            title: 'Newton\'s First Law of Motion: Inertia',
            expected: {
              los: ['k12phys-ch04-s02-lo01', 'k12phys-ch04-s02-lo02'],
              tags: [
                {
                  value: 'context-cnxmod:640e3e84-09a5-4033-b2a7-b7fe5ec29dc6',
                  type: :cnxmod
                },
                {
                  value: 'k12phys-ch04-s02-lo01',
                  type: :lo,
                  description: 'Describe Newton’s first law and friction',
                  teks: 'teks-112-39-c-4d'
                },
                {
                  value: 'k12phys-ch04-s02-lo02',
                  type: :lo,
                  description: 'Discuss the relationship between mass and inertia',
                  teks: 'teks-112-39-c-4d'
                },
                {
                  value: 'teks-112-39-c-4d',
                  type: :teks,
                  name: '(4D)',
                  description: 'calculate the effect of forces on objects, including the law of inertia, the relationship between force and acceleration, and the nature of force pairs between objects'
                }
              ],
              is_intro: false
            }
          }
        ]

        @hashes_with_pages = VCR.use_cassette('OpenStax_Cnx_V1_Page/with_parts_of_k12phys',
                                              VCR_OPTS) do
          cnx_page_infos.map do |hash|
            [hash, page_for(hash).tap{ |page| page.full_hash }]
          end
        end
      end
    end

    it 'provides info about the page for the given hash' do
      @hashes_with_pages.each do |hash, page|
        expect(page.id).to eq hash[:id]
        expect(page.url).to include(hash[:id])
        expect(page.title).to eq page.parsed_title[:text]
        expect(page.full_hash).not_to be_empty
        expect(page.content).not_to be_blank
        expect(page.doc).not_to be_nil
        expect(page.root).not_to be_nil
        expect(page.los).not_to be_nil
        expect(page.tags).not_to be_nil
      end
    end

    it "extracts the LO's from the page" do
      @hashes_with_pages.each do |hash, page|
        expect(page.los).to eq hash[:expected][:los]
      end
    end

    it 'can identify chapter introduction pages' do
      @hashes_with_pages.each do |hash, page|
        expect(page.is_intro?).to eq hash[:expected][:is_intro]
      end
    end

    it 'extracts tag names and descriptions from the page' do
      @hashes_with_pages.each do |hash, page|
        expect(Set.new page.tags).to eq Set.new(hash[:expected][:tags])
      end
    end
  end

  context 'is a preface page' do
    it 'identifies a preface' do
      page = OpenStax::Cnx::V1::Page.new(
        id: '7c42370b-c3ad-48ac-9620-d15367b882c6@19',
        url: 'https://archive.cnx.org/contents/14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22@15.1:7c42370b-c3ad-48ac-9620-d15367b882c6@19.json'
      )
      expect(page.preface?).to be_truthy
      expect(page.index?).to be_falsey
    end
  end

  context 'is a index page' do
    it 'identifies a index' do
      page = OpenStax::Cnx::V1::Page.new(
        id: '808e7285-11d0-51fe-94fb-1747bab95c65@15.1',
        url: 'https://archive.cnx.org/contents/14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22@15.1:808e7285-11d0-51fe-94fb-1747bab95c65@15.1.json'
      )
      expect(page.index?).to be_truthy
      expect(page.preface?).to be_falsey
    end
  end

  context 'parsing html titles' do
    it 'parses parts' do
      page = OpenStax::Cnx::V1::Page.new(
        id: '123',
        hash: { 'title' => '<span class="os-number">2.1</span><span class="os-divider"> </span><span class="os-text">Atoms, Isotopes, Ions, and Molecules: The Building Blocks</span>' }
      )
      expect(page.baked_book_location).to eq ['2', '1']
      expect(page.title).to eq 'Atoms, Isotopes, Ions, and Molecules: The Building Blocks'
    end

    it 'leaves baked_book_location blank if not present' do
      page = OpenStax::Cnx::V1::Page.new(
        id: '123',
        hash: { 'title' => '<span class="os-text">Review Questions</span>' }
      )
      expect(page.baked_book_location).to eq []
      expect(page.title).to eq 'Review Questions'
    end

    it 'continues to function for plain text titles' do
      page = OpenStax::Cnx::V1::Page.new(
        id: '123',
        hash: { 'title' => 'Hello World!' }
      )
      expect(page.baked_book_location).to be_empty
      expect(page.title).to eq 'Hello World!'
    end

  end

  protected

  def page_for(hash)
    OpenStax::Cnx::V1::Page.new(hash: HashWithIndifferentAccess.new(hash).except(:expected))
  end

end

require 'spec_helper'
require 'nokogiri'
require 'fixtures/document'

describe Document::Post do
  context 'valid document' do
    let(:filename) { fixture('wrx.xml') }
    let(:document) { Nokogiri::XML(filename.read).xpath('//channel').at_xpath('item')}
    subject { described_class.call(document) }

    it 'has an id' do
      expect(subject.id).to eq 3
    end

    it 'has a title' do
      expect(subject.title).to eq "Welcome To Wrxer News."
    end

    it 'has a content' do
      expect(subject.content).to match /Welcome to/
    end

    it 'has an excerpt' do
      expect(subject.excerpt).to eq "Excerpt Text"
    end

    it 'has a slug' do
      expect(subject.name).to eq "welcome-to-wrxer-news"
    end

    it 'has a post date' do
      expect(subject.published_at).to eq Time.parse("2007-11-17 21:30:51")
    end

    it 'has a category' do
      expect(subject.category).to be_a Document::Category
    end

    it 'has is_sticky' do
      expect(subject.is_sticky).to eq 0
    end

    it 'has postmetas' do
      expect(subject.postmetas.first).to be_a Document::Postmeta
    end

    it 'does not have a not foo' do
      expect { subject.foo }.to raise_error(
        NoMethodError, "undefined method 'foo' for Document::Post")
    end
  end

  context "nil attribute case" do
    let(:filename) { fixture('missing_fields.xml') }
    let(:document) { Nokogiri::XML(filename.read).xpath('//channel').at_xpath('item')}
    subject { described_class.call(document) }

    it 'returns nil for nil integer' do
      expect(subject.id).to eq nil
    end

    it 'returns nil for text' do
      expect(subject.name).to eq nil
    end

    it 'returns nil for time' do
      expect(subject.published_at).to eq nil
    end
  end

  context "for missing node" do
    let(:filename) { fixture('missing_fields.xml') }
    let(:document) { Nokogiri::XML(filename.read).xpath('//channel').xpath('item')[1]}
    subject { described_class.new(document) }

    it 'returns nil for category' do
      expect(subject.category).to eq nil
    end
  end
end

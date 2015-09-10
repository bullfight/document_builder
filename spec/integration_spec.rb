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

    it 'has a post_date' do
      expect(subject.post_date).to eq Time.parse("2007-11-17 15:30:51")
    end

    it 'has a utc post_date_gmt' do
      expect(subject.post_date_gmt).to eq Time.parse("2007-11-17 21:30:51 UTC")
      expect(subject.post_date_gmt.utc?).to eq true
    end

    it 'has a utc pub_date' do
      expect(subject.pub_date).to eq(
        Time.parse("Sat, 17 Nov 2007 21:30:51 +0000"))
      expect(subject.pub_date.utc?).to eq true
    end

    it 'has a category' do
      expect(subject.category).to be_a Document::Category
      expect(subject.category.domain).to eq "category"
      expect(subject.category.body).to eq "Wrxer News"
    end

    it 'has is_sticky' do
      expect(subject.is_sticky).to eq 0
    end

    it 'has postmetas' do
      expect(subject.postmetas.first).to be_a Document::Postmeta
      expect(subject.postmetas.first.key).to_not eq nil
    end

    it 'does not have a not foo' do
      expect { subject.foo }.to raise_error(
        NoMethodError, "undefined method 'foo' for Document::Post")
    end
  end

  context "nil property case" do
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
      expect(subject.post_date_gmt).to eq nil
    end
  end

  context "for missing node" do
    let(:filename) { fixture('missing_fields.xml') }
    let(:document) { Nokogiri::XML(filename.read).xpath('//channel').xpath('item')[1]}
    subject { described_class.new(document) }

    it 'returns nil for category' do
      expect(subject.category).to be_a Document::Category
    end
  end
end

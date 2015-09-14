require 'spec_helper'
require 'nokogiri'

RSpec.describe DocumentBuilder::Model do
  class EmptyDocument
    include DocumentBuilder::Model
  end

  class ListItem
    include DocumentBuilder::Model
    property :name, type: TextProperty
  end

  class SomeDocument
    include DocumentBuilder::Model
    root "//root"
    collection :collection, selector: "//collection//inner-list-item", type: ListItem
    collection :outer_collection, selector: "outer-list-item", type: ListItem
    property :property, selector: "//property", type: TextProperty
  end

  context 'for an xml document' do
    let(:xml) {
      <<-XML
        <root>
          <collection>
            <inner-list-item>Inner Item 1</inner-list-item>
            <inner-list-item>Inner Item 2</inner-list-item>
          </collection>
          <outer-list-item>Outer Item 1</outer-list-item>
          <outer-list-item>Outer Item 2</outer-list-item>
          <property>Some Property</property>
        </root>
      XML
    }

    let(:document) { Nokogiri::XML(xml) }

    subject { SomeDocument.new(document) }

    it 'returns the root' do
      expect(subject.root).to eq "//root"
    end

    it 'returns an innner collection' do
      expect(subject.collection).to be_a DocumentBuilder::Collection
      expect(subject.collection.first).to be_a ListItem
      expect(subject.collection.first.name).to eq "Inner Item 1"
    end

    it 'returns an outer collection' do
      expect(subject.outer_collection).to be_a DocumentBuilder::Collection
      expect(subject.outer_collection.first).to be_a ListItem
      expect(subject.outer_collection.first.name).to eq "Outer Item 1"
    end

    it 'returns a property' do
      expect(subject.property).to eq "Some Property"
    end
  end


  context 'for an empty document' do
    let(:document) { Nokogiri::XML("") }
    subject { EmptyDocument.new(document) }

    it 'returns an empty document' do
      expect(subject).to be_a EmptyDocument
    end

    it 'is serialized' do
      expect(subject.to_s).to be_a String
    end
  end
end

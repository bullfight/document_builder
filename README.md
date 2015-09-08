# DocumentBuilder

[![Build Status](https://travis-ci.org/bullfight/document_builder.svg?branch=master)](https://travis-ci.org/bullfight/document_builder)

This is a small set of modules for building up xpath based document attributes
from a nokogir document object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'document_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install document_builder

## Usage

### Documents can be built using the Model and Collection modules as seen in the
following example

```ruby
class ListItem
  include DocumentBuilder::Model
  property :name, type: Text
end

class SomeDocument
  include DocumentBuilder::Model
  root "//root"
  collection :collection, selector: "//collection", class: ListItem do
    property :name, selector: "//inner-list-item"
  end

  collection :outer_collection, selector: "//outer-list-item", class: ListItem
  property :property, selector: "//property", type: Text
end
```

```ruby
require 'document_builder'
require 'nokogiri'

DOCUMENT = <<-XML
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

document = Nokogiri::XML(DOCUMENT)
some_document = SomeDocument.new(document)

=> #<SomeDocument:0x3fd4799693ac> Attributes: {
  "collection": [
    { "name": "Inner Item 1" },
    { "name": "Inner Item 2" }
  ],
  "outer_collection": [
    { "name": "Outer Item 1" },
    { "name": "Outer Item 2" }
  ],
  "property": "Some Property"
}

some_document.property
=> "Some Property"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/document_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

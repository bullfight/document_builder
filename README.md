# DocumentBuilder

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
module Document
  class Category
    include DocumentBuilder::Model
    xpath 'category'
    attribute :domain, 'domain', DocumentBuilder::ElementAttribute
    attribute :nicename, 'nicename', DocumentBuilder::ElementAttribute
    attribute :body, nil, DocumentBuilder::ChildAttribute
  end

  class Postmeta
    include DocumentBuilder::Model
    xpath 'postmeta'
    attribute :key, "wp:meta_key"
    attribute :value, "wp:meta_value", DocumentBuilder::IntegerAttribute
  end

  class PostmetaCollection
    include DocumentBuilder::Collection
    xpath "item"
    collection :postmeta, "//wp:postmeta", Postmeta
  end

  class Post
    include DocumentBuilder::Model
    xpath "item"
    attribute :title
    attribute :link
    attribute :pub_date, "pubDate", DocumentBuilder::TimeAttribute
    attribute :creator, "dc:creator"
    attribute :content, "content:encoded"
    attribute :excerpt, "excerpt:encoded"
    attribute :id, "wp:post_id", DocumentBuilder::IntegerAttribute
    attribute :published_at, 'wp:post_date_gmt', DocumentBuilder::TimeAttribute
    attribute :comment_status, "wp:comment_status"
    attribute :ping_status, "wp:ping_status"
    attribute :name, 'wp:post_name'
    attribute :status, "wp:status"
    attribute :parent, "wp:post_parent", DocumentBuilder::IntegerAttribute
    attribute :menu_order, "wp:menu_order", DocumentBuilder::IntegerAttribute
    attribute :type, "wp:post_type"
    attribute :is_sticky, "wp:is_sticky", DocumentBuilder::IntegerAttribute
    attribute :category, "category", Category
    attribute :postmetas, 'item', PostmetaCollection
  end
end

### Using Model Objects

```ruby
# Read an xml file
url = "https://raw.githubusercontent.com/bullfight/wrxer/master/spec/fixtures/wrx.xml"
uri = URI.parse(url)

uri.open do |file|
  document = Nokogiri::XML(file.read).xpath('//channel').at_xpath('item')}
end

post = Document::Post.call(document)

=> #<Wrxer::Post:0x3fd4799693ac> Attributes: {
  "title": "Welcome To Wrxer News.",
  "link": "https://wrxernews.wordpress.com/2007/11/17/welcome-to-wrxer-news/",
  "pub_date": "2007-11-17 21:30:51 +0000",
  "creator": "wrxernews",
  "content": "Welcome to <strong>Wrxer News</strong> - The most up-to-date and reliable source for Wrxer news.",
  "excerpt": "Excerpt Text",
  "id": 3,
  "published_at": "2007-11-17 21:30:51 -0800",
  "comment_status": "open",
  "ping_status": "open",
  "name": "welcome-to-wrxer-news",
  "status": "publish",
  "parent": 0,
  "menu_order": 0,
  "type": "post",
  "is_sticky": 0,
  "category": {
    "domain": "category",
    "nicename": "wrxer-news",
    "body": "Wrxer News"
  },
  "postmetas": {
    "data": "#<Enumerator::Lazy:0x007fa8f315a970>"
  },
  "comments": {
    "data": "#<Enumerator::Lazy:0x007fa8f315a3f8>"
  }
}
post.title
=> "Welcome To Wrxer News."

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/document_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

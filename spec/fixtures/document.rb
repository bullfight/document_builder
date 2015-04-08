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

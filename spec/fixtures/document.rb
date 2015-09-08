module Document
  class Category
    include DocumentBuilder::Model
    root 'category'
    property :domain, 'domain', DocumentBuilder::ElementProperty
    property :nicename, 'nicename', DocumentBuilder::ElementProperty
    property :body, nil, DocumentBuilder::ChildProperty
  end

  class Postmeta
    include DocumentBuilder::Model
    root 'postmeta'
    property :key, "wp:meta_key"
    property :value, "wp:meta_value", DocumentBuilder::IntegerProperty
  end

  class PostmetaCollection
    include DocumentBuilder::Collection
    root "item"
    collection :postmeta, "//wp:postmeta", Postmeta
  end

  class Post
    include DocumentBuilder::Model
    root "item"
    property :title
    property :link
    property :pub_date, "pubDate", DocumentBuilder::UtcTimeProperty
    property :creator, "dc:creator"
    property :content, "content:encoded"
    property :excerpt, "excerpt:encoded"
    property :id, "wp:post_id", DocumentBuilder::IntegerProperty
    property :post_date, 'wp:post_date', DocumentBuilder::TimeProperty
    property :post_date_gmt, 'wp:post_date_gmt', DocumentBuilder::UtcTimeProperty
    property :comment_status, "wp:comment_status"
    property :ping_status, "wp:ping_status"
    property :name, 'wp:post_name'
    property :status, "wp:status"
    property :parent, "wp:post_parent", DocumentBuilder::IntegerProperty
    property :menu_order, "wp:menu_order", DocumentBuilder::IntegerProperty
    property :type, "wp:post_type"
    property :is_sticky, "wp:is_sticky", DocumentBuilder::IntegerProperty
    property :category, "category", Category
    property :postmetas, 'item', PostmetaCollection
  end
end

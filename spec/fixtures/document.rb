module Document
  class Category
    include DocumentBuilder::Model
    tag :domain, selector: 'domain'
    tag :nicename, selector: 'nicename'
    property :body, selector: 'category'
  end

  class Postmeta
    include DocumentBuilder::Model
    property :key, selector: "wp:meta_key"
    property :value, selector: "wp:meta_value", type: IntegerProperty
  end

  class Post
    include DocumentBuilder::Model
    root "//item"
    property :title, selector: "title"
    property :link, selector: "link"
    property :pub_date, selector: "pubDate", type: UtcTimeProperty
    property :creator, selector: "dc:creator"
    property :content, selector: "content:encoded"
    property :excerpt, selector: "excerpt:encoded"
    property :id, selector: "wp:post_id", type: IntegerProperty
    property :post_date, selector: 'wp:post_date', type: TimeProperty
    property :post_date_gmt, selector: 'wp:post_date_gmt', type: UtcTimeProperty
    property :comment_status, selector: "wp:comment_status"
    property :ping_status, selector: "wp:ping_status"
    property :name, selector: 'wp:post_name'
    property :status, selector: "wp:status"
    property :parent, selector: "wp:post_parent", type: IntegerProperty
    property :menu_order, selector: "wp:menu_order", type: IntegerProperty
    property :type, selector: "wp:post_type"
    property :is_sticky, selector: "wp:is_sticky", type: IntegerProperty
    property :category, selector: "//category", type: Category
    collection :postmetas, selector: '//wp:postmeta', type: Postmeta
  end
end

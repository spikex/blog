Factory.define(:post) do |factory|
  factory.title 'Some Title'
  factory.body 'Some Body'
end

Factory.define(:published_post, :class => Post) do |factory|
  factory.title 'Some Title'
  factory.body 'Some Body'
  factory.published true
end

Factory.define(:comment) do |comment|
  comment.association :post
  comment.title 'Comment Title'
  comment.body 'Comment Body'
end


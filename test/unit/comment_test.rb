require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  should_belong_to :post
  should_require_attributes :post_id, :title, :body
end

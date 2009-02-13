module PostsHelper
  def display_author_of(post)
    if post.author.blank?
      'Anonymous'
    else
      post.author
    end
  end
end

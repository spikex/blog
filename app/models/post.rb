class Post < ActiveRecord::Base
  validates_presence_of :title, :body
  has_many :comments
  
  named_scope :published, :conditions => {:published => true}
  named_scope :newer, :order => 'created_at DESC'
  
  def self.latest
    published.newer
  end
end

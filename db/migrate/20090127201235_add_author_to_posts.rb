class AddAuthorToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.string :author
    end
  end

  def self.down
    change_table :posts do |t|
      t.remove :author
    end
  end
end
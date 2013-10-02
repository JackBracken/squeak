class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string  :title
      t.text    :body
      t.timestamps
    end
    Post.create(title: "Test post number 1!", body: "Lauren Ipsum fle   xum nipsum")
    Post.create(title: "Test post the second.", body: "Aerith and Bob~~")
  end

  def down
    drop_table :posts
  end
end

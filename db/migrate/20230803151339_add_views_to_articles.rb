class AddViewsToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :views, :int
  end
end

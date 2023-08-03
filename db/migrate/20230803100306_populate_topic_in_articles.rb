class PopulateTopicInArticles < ActiveRecord::Migration[7.0]
  def change

    def up
      Article.all.each do |article|
        article.update(topic: 'default_topic')
      end
    end
  
    def down
      Article.update_all(topic: nil)
    end
  end
end

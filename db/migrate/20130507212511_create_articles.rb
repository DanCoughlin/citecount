class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :journal
      t.string :reference_type
      t.string :author
      t.integer :year

      t.timestamps
    end
  end
end

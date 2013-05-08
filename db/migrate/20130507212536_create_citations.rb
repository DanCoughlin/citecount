class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.integer :article_id
      t.integer :cite_id

      t.timestamps
    end
  end
end

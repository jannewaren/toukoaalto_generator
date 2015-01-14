class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :start
      t.string :text
      t.string :url
      t.string :slug
      t.integer :views

      t.timestamps null: false
    end
  end
end

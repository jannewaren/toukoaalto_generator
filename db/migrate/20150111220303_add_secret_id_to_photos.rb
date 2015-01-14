class AddSecretIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :secret_id, :string
  end
end

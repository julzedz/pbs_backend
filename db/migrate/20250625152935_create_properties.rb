class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :title
      t.integer :purpose
      t.string :street
      t.integer :property_type
      t.decimal :price
      t.text :description
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :instagram_video_link
      t.references :user, null: false, foreign_key: true
      t.references :locality, null: false, foreign_key: true

      t.timestamps
    end
  end
end

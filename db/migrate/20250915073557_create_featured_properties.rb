class CreateFeaturedProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :featured_properties do |t|
      t.jsonb :property_ids, default: []

      t.timestamps
    end
  end
end

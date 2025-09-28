class AddIndexesToProperties < ActiveRecord::Migration[7.1]
  def change
    add_index :properties, :purpose
    add_index :properties, :property_type
    add_index :properties, :price
    add_index :properties, :bedrooms
  end
end

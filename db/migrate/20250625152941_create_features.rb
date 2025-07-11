class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.string :name

      t.timestamps
    end
    add_index :features, :name, unique: true
  end
end

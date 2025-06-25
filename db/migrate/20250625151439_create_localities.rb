class CreateLocalities < ActiveRecord::Migration[7.1]
  def change
    create_table :localities do |t|
      t.string :name
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end

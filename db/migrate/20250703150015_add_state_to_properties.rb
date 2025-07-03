class AddStateToProperties < ActiveRecord::Migration[7.1]
  def change
    add_reference :properties, :state, foreign_key: true # nullable for now
  end
end

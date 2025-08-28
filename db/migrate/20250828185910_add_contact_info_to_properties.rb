class AddContactInfoToProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :contact_name, :string
    add_column :properties, :contact_number, :string
  end
end

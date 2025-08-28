class RenameContactNumberToContactPhone < ActiveRecord::Migration[7.1]
  def change
    rename_column :properties, :contact_number, :contact_phone
  end
end

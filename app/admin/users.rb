ActiveAdmin.register User do
  filter :email
  filter :first_name
  filter :last_name
  # filter :jti
  filter :created_at
  filter :telephone
  filter :properties

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :telephone
      row :created_at
      row :updated_at
    end

    panel "Properties" do
      if user.properties.any?
        table_for user.properties do
          column :title
          column :purpose
          column :property_type
          column :price
          column :bedrooms
          column :bathrooms
          column :instagram_video_link
          column :locality
          column :state
          column :created_at
          column :updated_at
          column :contact_name
          column :contact_phone
        end
      else
        para "No properties found"
      end
    end
  end

  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :jti, :telephone
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :jti, :telephone]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

ActiveAdmin.register Property do
  filter :title
  filter :purpose
  filter :street
  filter :property_type
  filter :price
  filter :description
  filter :bedrooms
  filter :bathrooms
  filter :instagram_video_link
  filter :user
  filter :locality
  filter :state
  filter :contact_name
  filter :contact_phone
  filter :created_at
  # filter :updated_at
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :purpose, :street, :property_type, :price, :description, :bedrooms, :bathrooms, :instagram_video_link, :user_id, :locality_id, :state_id, :contact_name, :contact_phone
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :purpose, :street, :property_type, :price, :description, :bedrooms, :bathrooms, :instagram_video_link, :user_id, :locality_id, :state_id, :contact_name, :contact_phone]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

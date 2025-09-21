ActiveAdmin.register FeaturedProperty do
  actions :all, except: [:new, :destroy]

  permit_params property_ids: []

  controller do
    def index
      featured = FeaturedProperty.first_or_create
      redirect_to edit_admin_featured_property_path(featured)
    end

    def find_resource
      FeaturedProperty.first_or_create
    end

  end

  form do |f|
    f.inputs do
      f.input :property_ids, as: :check_boxes, collection: Property.all.map { |p| [p.title, p.id] }

      # This is the list of properties that are currently featured.
      div id: 'selected_properties_list', class: 'border-2 border-dashed border-gray-300 p-4 rounded-lg' do
        if f.object.property_ids.present?
          Property.where(id: f.object.property_ids).each do |property|
            span class: 'property-tag inline-block bg-blue-100 text-blue-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded-full' do
              text_node "#{property.title} (ID: #{property.id})"
            end
          end
        else
          text_node 'No featured properties selected.'
        end
      end
    end

    f.actions
  end
end
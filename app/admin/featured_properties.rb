ActiveAdmin.register FeaturedProperty do
  permit_params property_ids: []

  controller do
    before_action only: [:new, :create] do
      if FeaturedProperty.any?
        redirect_to edit_admin_featured_property_path(FeaturedProperty.first)
      end
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
              link_to '×', '#', class: 'remove-property-button text-red-500 hover:text-red-700 ml-1', data: { id: property.id }
            end
          end
        else
          text_node 'No featured properties selected.'
        end
      end

      # This is a search box to find and add new properties.
      f.input :add_property, as: :select, label: 'Add Property', collection: [],
              input_html: {
                class: 'select2_with_ajax',
                data: {
                  url: admin_properties_path(format: :json),
                  placeholder: 'Search for a property...',
                  ajax: {
                    dataType: 'json',
                    delay: 250,
                    data: 'params => { q: params.term }',
                    processResults: 'data => ({ results: data.map(p => ({ id: p.id, text: p.title })) })'
                  }
                }
              }
    end

    f.actions
  end
end
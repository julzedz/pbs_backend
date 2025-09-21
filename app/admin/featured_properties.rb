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
        table do
          thead do
            tr do
              th "Title"
              th "ID"
              th "Price"
              th "Purpose"
              th "Type"
            end
          end
          tbody do
            Property.where(id: f.object.property_ids).each do |property|
              tr do
                td property.title
                td property.id
                td number_to_currency(property.price)
                td property.purpose
                td property.property_type
              end
            end
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
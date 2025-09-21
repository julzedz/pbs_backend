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
    f.inputs "Featured Properties Management" do
      f.input :property_ids,
              as: :select,
              multiple: true,
              collection: Property.all.map { |p| ["#{p.title} (ID: #{p.id})", p.id] },
              input_html: { class: "select2" },
              hint: "Select multiple properties to feature. Use Ctrl+Click (or Cmd+Click on Mac) to select multiple properties."
    end

    f.actions
  end

  show do
    attributes_table do
      row "Featured Properties" do |featured|
        if featured.property_ids.present? && featured.property_ids.reject(&:blank?).present?
          ul do
            Property.where(id: featured.property_ids.reject(&:blank?).map(&:to_i)).each do |property|
              li "#{property.title} (ID: #{property.id}) - #{number_to_currency(property.price)}"
            end
          end
        else
          "No featured properties"
        end
      end
    end
  end
end
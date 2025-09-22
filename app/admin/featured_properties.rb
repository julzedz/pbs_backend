ActiveAdmin.register FeaturedProperty do
  # --- CONFIGURATION ---
  actions :all, except: [:new, :destroy]
  permit_params property_ids: []

  # --- CONTROLLER LOGIC ---
  # Overriding controller actions to handle this singleton resource
  # and correctly merge property IDs on update.
  controller do
    def index
      featured = FeaturedProperty.first_or_create
      redirect_to edit_admin_featured_property_path(featured)
    end

    def find_resource
      FeaturedProperty.first_or_create
    end

    def update
      featured = find_resource

      # Sanitize and load existing property IDs
      existing_ids = featured.property_ids.reject(&:blank?).map(&:to_i)

      # Sanitize and load newly selected property IDs from the form
      newly_selected_ids = params.dig(:featured_property, :property_ids)&.reject(&:blank?)&.map(&:to_i) || []

      # Merge existing and new IDs, ensuring uniqueness
      updated_ids = (existing_ids + newly_selected_ids).uniq

      if featured.update(property_ids: updated_ids)
        flash[:notice] = "Featured properties were successfully updated."
      else
        flash[:alert] = "Failed to update featured properties: #{featured.errors.full_messages.join(', ')}"
      end
      redirect_to edit_admin_featured_property_path(featured)
    end
  end

  # --- CUSTOM MEMBER ACTIONS ---
  # This action is not used by your form but kept as is.
  member_action :add_property, method: :post do
    featured = FeaturedProperty.first_or_create
    featured.property_ids = featured.property_ids.reject(&:blank?).map(&:to_i)
    property_id = params[:property_id].to_i

    if property_id.present? && !featured.property_ids.include?(property_id)
      featured.property_ids << property_id
      featured.save
      flash[:notice] = "Property #{property_id} added to featured list"
    elsif featured.property_ids.include?(property_id)
      flash[:alert] = "Property #{property_id} is already featured"
    else
      flash[:alert] = "Invalid property ID: #{property_id}"
    end
    redirect_to edit_admin_featured_property_path(featured)
  end

  # Your working remove action - unchanged
  member_action :remove_property, method: :delete do
    featured = FeaturedProperty.first_or_create
    featured.property_ids = featured.property_ids.reject(&:blank?).map(&:to_i)
    property_id = params[:property_id].to_i

    if property_id.present? && featured.property_ids.include?(property_id)
      featured.property_ids.delete(property_id)
      featured.save
      flash[:notice] = "Property #{property_id} removed from featured list"
    else
      flash[:alert] = "Property #{property_id} not found in featured list."
    end
    redirect_to edit_admin_featured_property_path(featured)
  end

  # --- FORM DEFINITION ---
  form do |f|
    f.inputs "Add New Property to Featured List" do
      # This select input allows users to choose new properties to add.
      f.input :property_ids,
              label: "Select Properties to Add",
              as: :select,
              multiple: true,
              collection: Property.all.map { |p| ["#{p.title} (ID: #{p.id})", p.id] },
              input_html: { class: "select2" },
              hint: "To select multiple properties, use Ctrl+Click (or Cmd+Click on Mac)."
      
      # The custom JavaScript button that submits the main form.
      div do
        f.button "Add Selected to Featured List", type: 'button', onclick: "addSelectedPropertiesToFeatured()", class: "add-property-btn"
      end
      
      script do
        <<~JS.html_safe
          function addSelectedPropertiesToFeatured() {
            const selectElement = document.querySelector('select[name="featured_property[property_ids][]"]');
            if (selectElement.selectedOptions.length === 0) {
              alert('Please select at least one property to add.');
              return;
            }
            if (confirm('Add the selected properties to the featured list?')) {
              // Submit the main form to trigger the custom 'update' action
              document.querySelector('form.formtastic').submit();
            }
          }
        JS
      end
    end
    
    # This section displays the properties that are currently featured.
    f.inputs "Currently Featured Properties" do
      featured_properties = Property.where(id: f.object.property_ids.reject(&:blank?).map(&:to_i))
      
      if featured_properties.present?
        table_for featured_properties, class: 'index_table' do
          column "Title", :title
          column "ID", :id
          column "Price" do |property|
            number_to_currency(property.price)
          end
          column "Purpose" do |property|
            property.purpose.humanize
          end
          column "Type" do |property|
            property.property_type.humanize
          end
          column "Actions" do |property|
            link_to "Remove", 
                    remove_property_admin_featured_property_path(f.object, property_id: property.id), 
                    method: :delete,
                    class: "button",
                    style: "background-color: #dc3545; color: white;",
                    data: { confirm: "Are you sure you want to remove this property?" }
          end
        end
      else
        div class: 'no-content' do
          text_node 'No featured properties have been selected yet.'
        end
      end
    end
    
    # We no longer need the hidden field here.
    # The standard actions block is also omitted to avoid confusion with the custom "Add" button.
    # f.actions
  end

  # --- SHOW PAGE DEFINITION ---
  show do
    attributes_table do
      row "Featured Properties" do |featured|
        properties = Property.where(id: featured.property_ids.reject(&:blank?).map(&:to_i))
        if properties.present?
          ul do
            properties.each do |property|
              li link_to("#{property.title} (ID: #{property.id})", admin_property_path(property))
            end
          end
        else
          "No featured properties."
        end
      end
    end
  end
end
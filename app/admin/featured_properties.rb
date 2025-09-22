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

  member_action :add_property, method: :post do
    featured = FeaturedProperty.first_or_create

    # Clean up property_ids to remove empty strings and convert to integers
    featured.property_ids = featured.property_ids.reject(&:blank?).map(&:to_i)
    featured.save

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

  member_action :remove_property, method: :delete do
    featured = FeaturedProperty.first_or_create

    # Clean up property_ids to remove empty strings and convert to integers
    featured.property_ids = featured.property_ids.reject(&:blank?).map(&:to_i)
    featured.save

    property_id = params[:property_id].to_i

    if property_id.present? && featured.property_ids.include?(property_id)
      featured.property_ids.delete(property_id)
      featured.save
      flash[:notice] = "Property #{property_id} removed from featured list"
    else
      flash[:alert] = "Property #{property_id} not found in featured list. Current IDs: #{featured.property_ids.join(', ')}"
    end

    redirect_to edit_admin_featured_property_path(featured)
  end # Missing end keyword was here.

  form do |f|
    f.inputs "Add New Property to Featured List" do
      f.input :property_ids,
              as: :select,
              multiple: true,
              collection: Property.all.map { |p| ["#{p.title} (ID: #{p.id})", p.id] },
              input_html: { class: "select2" },
              hint: "To select multiple properties, use Ctrl+Click (or Cmd+Click on Mac)."
      
      div do
        link_to "Add to Featured List", 
                "#", 
                class: "button add-property-btn",
                onclick: "addSelectedPropertiesToFeatured()"
      end
      
      script do
        <<~JS.html_safe
          function addSelectedPropertiesToFeatured() {
            const selectElement = document.querySelector('select[name="featured_property[property_ids][]"]');
            const selectedValues = Array.from(selectElement.selectedOptions).map(option => option.value);
            
            if (selectedValues.length === 0) {
              alert('Please select at least one property first');
              return;
            }
            
            if (confirm('Add selected properties to featured list?')) {
              // Submit the form with selected properties
              const form = document.querySelector('form');
              form.submit();
            }
          }
        JS
      end
    end
    
  
    f.inputs "Currently Featured Properties" do
      if f.object.property_ids.reject(&:blank?).present?
        table class: 'index_table' do
          thead do
            tr do
              th "Title"
              th "ID"
              th "Price"
              th "Purpose"
              th "Type"
              th "Actions"
            end
          end
          tbody do
            Property.where(id: f.object.property_ids.reject(&:blank?).map(&:to_i)).each do |property|
              tr do
                td property.title
                td property.id
                td number_to_currency(property.price)
                td property.purpose.humanize
                td property.property_type.humanize
                td do
                  link_to "Remove", 
                          remove_property_admin_featured_property_path(f.object, property_id: property.id), 
                          method: :delete,
                          class: "button",
                          style: "background-color: #dc3545; color: white; padding: 5px 10px; border-radius: 3px; text-decoration: none;",
                          data: { 
                            confirm: "Remove this property from featured list?" 
                          }
                end
              end
            end
          end
        end
      else
        div class: 'no-content' do
          text_node 'No featured properties selected.'
        end
      end
    end

    # Hidden field to maintain the current property_ids
    f.input :property_ids, as: :hidden, value: f.object.property_ids.join(',')

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
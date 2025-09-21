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
    property_id = params[:property_id].to_i
    
    Rails.logger.info "=== ADD DEBUG ==="
    Rails.logger.info "Property ID: #{property_id}"
    Rails.logger.info "Featured IDs: #{featured.property_ids}"
    Rails.logger.info "Includes?: #{featured.property_ids.include?(property_id)}"
    
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
    property_id = params[:property_id].to_i
    
    Rails.logger.info "=== REMOVE DEBUG ==="
    Rails.logger.info "Property ID: #{property_id}"
    Rails.logger.info "Featured IDs: #{featured.property_ids}"
    Rails.logger.info "Includes?: #{featured.property_ids.include?(property_id)}"
    
    if property_id.present? && featured.property_ids.include?(property_id)
      featured.property_ids.delete(property_id)
      featured.save
      flash[:notice] = "Property #{property_id} removed from featured list"
    else
      flash[:alert] = "Property #{property_id} not found in featured list. Current IDs: #{featured.property_ids.join(', ')}"
    end
    
    redirect_to edit_admin_featured_property_path(featured)
  end

  form do |f|
    f.inputs "Add New Property to Featured List" do
      div class: 'field' do
        label "Select Property to Add"
        
        # Show available properties for debugging
        div style: "margin-bottom: 10px;" do
          text_node "Available properties: #{Property.count}"
          br
          text_node "Featured properties: #{f.object.property_ids.count}"
          br
          text_node "Featured IDs: #{f.object.property_ids.join(', ')}"
        end
        
        select_tag :new_property_id, 
                   options_from_collection_for_select(
                     Property.all, 
                     :id, 
                     :title
                   ),
                   { prompt: "Choose a property to add", class: "select2", id: "new_property_id" }
        
        div do
          link_to "Add Property", 
                  "#", 
                  class: "button add-property-btn",
                  onclick: "addPropertyToFeatured()"
        end
        
        javascript_tag do
          <<~JS
            function addPropertyToFeatured() {
              const selectElement = document.getElementById('new_property_id');
              const propertyId = selectElement.value;
              
              if (!propertyId) {
                alert('Please select a property first');
                return;
              }
              
              if (confirm('Add this property to featured list?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '#{add_property_admin_featured_property_path(f.object)}?property_id=' + propertyId;
                
                const methodInput = document.createElement('input');
                methodInput.type = 'hidden';
                methodInput.name = '_method';
                methodInput.value = 'POST';
                form.appendChild(methodInput);
                
                const tokenInput = document.createElement('input');
                tokenInput.type = 'hidden';
                tokenInput.name = 'authenticity_token';
                tokenInput.value = document.querySelector('meta[name="csrf-token"]').content;
                form.appendChild(tokenInput);
                
                document.body.appendChild(form);
                form.submit();
              }
            }
          JS
        end
      end
    end

    f.inputs "Currently Featured Properties" do
      if f.object.property_ids.present?
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
            Property.where(id: f.object.property_ids).each do |property|
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
        if featured.property_ids.present?
          ul do
            Property.where(id: featured.property_ids).each do |property|
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
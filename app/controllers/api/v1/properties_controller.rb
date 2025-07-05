module Api
  module V1
    class PropertiesController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_property, only: [:show, :update, :destroy]

      # GET /api/v1/properties
      def index
        @properties = filter_properties(Property.all)
        render json: PropertySerializer.new(@properties, include: [:user, :features, :state, :locality]).serializable_hash
      end

      # GET /api/v1/properties/1
      def show
        render json: PropertySerializer.new(@property, include: [:user, :features, :state, :locality]).serializable_hash
      end

      # POST /api/v1/properties
      def create
        @property = current_user.properties.build(property_params)

        # Attach the picture if present
        @property.picture.attach(params[:property][:picture]) if params[:property][:picture].present?

        # Attach the features if present
        @property.feature_ids = params[:property][:feature_ids] if params[:property][:feature_ids].present?

        if @property.save
          render json: PropertySerializer.new(@property).serializable_hash, status: :created
        else
          render json: @property.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/properties/1
      def update
        if @property.user == current_user
          if @property.update(property_params)
            render json: PropertySerializer.new(@property).serializable_hash
          else
            render json: @property.errors, status: :unprocessable_entity
          end
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end

      # DELETE /api/v1/properties/1
      def destroy
        if @property.user == current_user
          @property.destroy
          head :no_content
        else
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end

      private

      def set_property
        @property = Property.find(params[:id])
      end

      def property_params
        params.require(:property).permit(
          :title, :purpose, :street, :property_type, :price, :description,
          :bedrooms, :bathrooms, :instagram_video_link, :locality_id, :state_id,
          :picture, feature_ids: []
        )
      end

      def filter_properties(scope)
        scope = scope.where(purpose: params[:purpose]) if params[:purpose].present?
        scope = scope.where(property_type: params[:type]) if params[:type].present?
        scope = scope.where('bedrooms >= ?', params[:bedrooms]) if params[:bedrooms].present?
        scope = scope.where('price >= ?', params[:min_price]) if params[:min_price].present?
        scope = scope.where('price <= ?', params[:max_price]) if params[:max_price].present?
        scope = scope.where(state_id: params[:state_id]) if params[:state_id].present?
        scope = scope.where(locality_id: params[:locality_id]) if params[:locality_id].present?
        scope = scope.where(user_id: params[:user_id]) if params[:user_id].present?
        if params[:feature_ids].present?
          Array(params[:feature_ids]).each do |fid|
            scope = scope.joins(:features).where(features: { id: fid })
          end
        end
        if params[:search].present?
          q = "%#{params[:search]}%"
          scope = scope.where(
            'title ILIKE :q OR description ILIKE :q OR street ILIKE :q', q: q
          )
        end
        scope.distinct
      end
    end
  end
end 
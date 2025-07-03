module Api
  module V1
    class PropertiesController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_property, only: [:show, :update, :destroy]

      # GET /api/v1/properties
      def index
        @properties = Property.all
        render json: PropertySerializer.new(@properties, include: [:user, :features, :locality]).serializable_hash
      end

      # GET /api/v1/properties/1
      def show
        render json: PropertySerializer.new(@property, include: [:user, :features, :locality]).serializable_hash
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
          :bedrooms, :bathrooms, :instagram_video_link, :locality_id,
          :picture, feature_ids: []
        )
      end
    end
  end
end 
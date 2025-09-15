module Api
  module V1
    class FeaturedPropertiesController < ApplicationController
      def index
        featured = FeaturedProperty.first
        render json: PropertySerializer.new(featured.properties).serializable_hash
      end
    end
  end
end
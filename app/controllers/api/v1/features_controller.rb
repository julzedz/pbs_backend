module Api
  module V1
    class FeaturesController < ApplicationController

      # GET /api/v1/features
      def index
        @features = Feature.all
        render json: FeatureSerializer.new(@features).serializable_hash, status: :ok
      end

      private

      def feature_params
        params.require(:feature).permit(:name)
      end
    end
  end
end 
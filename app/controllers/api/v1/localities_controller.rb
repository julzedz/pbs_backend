module Api
  module V1
    class LocalitiesController < ApplicationController

      # GET /api/v1/localities
      def index
        @state = State.find(params[:state_id])
        @localities = @state.localities.order(:name)
        render json: LocalitySerializer.new(@localities).serializable_hash, status: :ok
      end
    end
  end
end 
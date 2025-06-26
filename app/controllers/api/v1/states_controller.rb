module Api
  module V1
    class StatesController < ApplicationController
      # GET /api/v1/states
      def index
        @states = State.all.order(:name)
        render json: StateSerializer.new(@states).serializable_hash
      end
    end
  end
end 